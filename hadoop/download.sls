#!py

'''
Download Hadoop from Apache

Apache checksum files do not conform to SaltStack's valid formats, so we must
parse the checksum file and return the checksum in a valid format.

Note that this file uses the
(py renderer)[https://docs.saltstack.com/en/latest/ref/renderers/all/salt.renderers.py.html].
The state object is returned from the run() function as a dictionary.
'''

from jinja2 import Environment
import requests
import pdb

def run():
  pdb.set_trace()
  env = Environment()
  settings_file = __salt__['cp.cache_file'](
    'salt://hadoop/settings.sls',
    saltenv='common'
  )

  with open(settings_file, 'r') as f:
    template = env.from_string(f.read())

  settings = template.make_module(vars={'salt': __salt__})

#  mirrors = []
#  for mirror in settings['hadoop']['source']['mirrors']:
#    mirrors.append(
#      '{0}/hadoop-{1}/hadoop-{1}.tar.gz'.format(mirror, settings['hadoop']['version'])
#    )
#
#  ret = requests.get(
#    '{0}/hadoop-{1}/hadoop-{1}.tar.gz.mds'.format(settings['hadoop']['source']['sum'], settings['hadoop']['version'])
#  )
#
#  _parse_apache_hash_file(ret)
#
  return {}
  #return {
  #  'hadoop_bin_downloaded': {
  #    'file_managed': [
  #      {'name': '/opt/hadoop-{}'.format(settings['hadoop']['version']}, 
  #      {'source': mirrors}, 
  #      {'source_hash': source_hash}
  #    ]
  #  }
  #}


def _parse_apache_hash_file(ret):
  True
  #split_text = ret.text.split('\n')
  #for i, line in enumerate(split_text):
  #  if line.split()[1] == 'sha256':
  #    hash_lines = split_text[i:]
