base:
  '*':
    - users
    - environment_list
    - base_mine

  'environment:*':
    - match: grain
    - environment


