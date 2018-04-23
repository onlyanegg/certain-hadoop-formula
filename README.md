A Salt formula to install hadoop

Currently supports HDFS and YARN

Known Issues:
------

- Hadoop HDFS NameNode deletes `/var` when it appears in
  `dfs.namenode.name.dir`. This means that we can't set the data dirs to
  any subdirectory of `/var` which is really where they should be. To work
  around this, we can set the current working directory in the systemd
  service file as `CurrentDirectory` and then specify a relative directory
  for `dfs.namenode.name.dir`.

  NOTE: This is still broken, because the format command doesn't take
  into account the service's working directory
