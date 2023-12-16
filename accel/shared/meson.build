fdta_ss = ss.source_set()

fdta_ss.add(files(
  'fdta-output.c',
  'fdta-basic-callback.c',
  'fdta-main.c',
  'fdta-callback.c',
  'fdta-target.c',
  'fdta-hashtable-wrapper.cpp',
  'fdta-vmi-common.cpp',
  'fdta-linux-vmi.cpp',
  'fdta-linux-procinfo.cpp',
  'fdta-vmi-msg-wrapper.cpp',
  'fdta-taint-memory.c',
  'fdta-taintcheck-opt.c',
  'fdta-taint-tcg.c',
  'fdta-tcpip-parser.c',
  'fdta-taint-propagate-msg.c'
))

specific_ss.add_all(when: 'CONFIG_TCG', if_true: fdta_ss)