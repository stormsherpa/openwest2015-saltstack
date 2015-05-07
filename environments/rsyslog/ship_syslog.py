#!/usr/bin/env python2.7

import sys
import os
import re
import datetime
import socket
import gzip

import boto
import boto.s3

from boto.s3.connection import S3Connection, Location
from boto.s3.key import Key

AWS_ACCESS_ID = 'fixme'
AWS_SECRET_KEY = 'fixme'
BUCKET = 'fixme'


APPGROUPS = (
    'mezzapp',
)


class LogfileInfo:
    def __init__(self, filename):
        self.filename = filename
        self.base_filename = os.path.basename(filename)
        self.appname = "default"
        for app in APPGROUPS:
            m = re.match("^{}".format(app), self.base_filename)
            if m:
                self.appname = app
                break
        m = re.match('.*(\d\d\d\d)-(\d+)-(\d+).*', self.base_filename)
        if m:
            year, month, day = m.groups()
            self.date = datetime.date(int(year),
                                      int(month),
                                      int(day))
        self.stat_info = os.stat(filename)

    def can_archive(self):
        archive_date = self.date + datetime.timedelta(days=2)
        return datetime.date.today() > archive_date

    def can_delete(self):
        delete_date = self.date + datetime.timedelta(days=30)
        return datetime.date.today() > delete_date

    def __str__(self):
        return "{}: {}, {}".format(self.base_filename,
                                   self.appname,
                                   self.date)


class ShipLogs:
    def __init__(self):
        self.connection = S3Connection(AWS_ACCESS_ID, AWS_SECRET_KEY)
        self.bucket = self.connection.get_bucket(BUCKET)
        self.hostname = socket.gethostname()


    def find_logs(self, log_path):
        for (dirpath, dirnames, filenames) in os.walk(log_path):
            for file_name in filenames:
                file_path = os.path.join(dirpath, file_name)
                file_info = LogfileInfo(file_path)
                if not file_info.can_archive():
                    print "File not ready for archive: {}".format(file_path)
                    continue
                if not self.is_gzip_file(file_path):
                    print "Compressing file: {}".format(file_path)
                    self.gzip_file(file_path)
                    continue
                if self.key_is_present(file_info):
                    key_info = self.key_is_present(file_info)
                    if key_info.size != file_info.stat_info.st_size:
                        print "Size in S3 doesn't match size on filesystem! " \
                              "{}".format(file_path)
                        continue
                    if file_info.can_delete():
                        print "Deleting archived log: {}".format(file_path)
                        os.unlink(file_path)
                    continue
                keyname = self.get_keyname(file_info)
                self.update_file(file_path, keyname)


    def get_keyname(self, file_info):
        return os.path.join(self.hostname,
                            file_info.appname,
                            "{}".format(file_info.date.year, '4d'),
                            "{}".format(file_info.date.month, '2d'),
                            file_info.base_filename)

    def key_is_present(self, file_info):
        keyname = self.get_keyname(file_info)
        return self.bucket.get_key(keyname)

    def is_gzip_file(self, filename):
        file, ext = os.path.splitext(filename)
        return ext == ".gz"

    def gzip_file(self, filename):
        gzfilename = "{}.gz".format(filename)
        gzfile = gzip.open(gzfilename, 'wb')
        with open(filename, 'rb') as raw_log:
            gzfile.writelines(raw_log)
        gzfile.close()
        os.unlink(filename)


    def update_file(self, filename, keyname):
        existing_key = self.bucket.get_key(keyname)
        if existing_key:
            print "File already in S3: {}".format(keyname)
            return
        print "Uploading file to S3: {}".format(keyname)
        new_key = self.bucket.new_key(keyname)
        new_key.set_contents_from_filename(filename)


if __name__ == '__main__':
    handler = ShipLogs()
    handler.find_logs(sys.argv[1])
