#!py

'''
Download Hadoop from Apache

Apache checksum files do not conform to SaltStack's valid formats, so we must
parse the checksum file and return the checksum in a valid format.

Note that this file uses the
(py renderer)[https://docs.saltstack.com/en/latest/ref/renderers/all/salt.renderers.py.html].
The state object is returned from the run() function as a dictionary.
'''

# Built-in libs
import os
import pdb

# 3rd party libs
from jinja2 import Environment, FileSystemLoader

def run():
  hadoop = import_hadoop_with_context()

  for mirror in hadoop['source']['mirrors']:
    mirrors.append(
      '{0}/hadoop-{1}/hadoop-{1}.tar.gz'.format(mirror, hadoop['version'])
    )

  if hadoop['source']['translate_sum'].lower() == 'true':
    source_hash = parse_apache_hash_file(
      '{0}/hadoop-{1}/hadoop-{1}.tar.gz.mds'.format(
        hadoop['source']['sum'],
        hadoop['version']
      )
    )
  else:
    source_hash = hadoop['source']['sum']

  return {
    'hadoop_bin_downloaded': {
      'file.managed': [
        {'name': '/opt/hadoop-{}.tar.gz'.format(hadoop['version'])}, 
        {'source': mirrors}, 
        {'source_hash': source_hash}
      ]
    }
  }

def import_hadoop_with_context():
  '''
  Render hadoop/settings.sls and return the hadoop object
  '''

  settings_file = __salt__['cp.cache_file'](
    'salt://hadoop/settings.sls',
    saltenv='common'
  )

  # The template directory needs to be one level above the directory where the
  # templates actually live, because settings.sls references 'hadoop/settings.sls'
  template_dir = os.sep.join(settings_file.split(os.sep)[:-2])

  env = Environment(extensions=[
      'jinja2.ext.do',
      'salt.utils.jinja.SerializerExtension'
    ],
      loader=FileSystemLoader(template_dir)
  )

  template = env.get_template(os.sep.join(['hadoop','settings.sls']))
  settings = template.make_module(vars={'salt': __salt__})

  return settings.hadoop

def parse_apache_hash_file(url):
  '''
  Parse the checksum file pointed to by `url` and return a checksum parseable
  by SaltStack

  Example checksum file:

  hadoop-3.0.0.tar.gz:    MD5 = 6D C5 F2 90 5B 43 EB AC  3D EF 0A EF AE 6F 41 0F
  hadoop-3.0.0.tar.gz:   SHA1 = 2D97 4865 FB21 56F6 7D11  5AD6 DCCD 5884 E175 5C6E
  hadoop-3.0.0.tar.gz: RMD160 = 0D27 2CFE 8A4D A221 40C9  BC48 774B 8E79 DFFF 18D8
  hadoop-3.0.0.tar.gz: SHA224 = 37AB152A F715D808 E4A32953 24C1C6D3 D05A0CCF
                                3497B633 547D6FCD
  hadoop-3.0.0.tar.gz: SHA256 = 726E28FA 7AEA71E4 587CE91E D3D96C56 B15777FC
                                859C09A7 438A6D00 92E08C74
  hadoop-3.0.0.tar.gz: SHA384 = 0FD969CB EA4B1011 852E03D7 6E20D6F3 07E559D3
                                994C6CAB D8655094 91E2798F 1E998BEB D1FE67DA
                                AC24AFC7 50C18270
  hadoop-3.0.0.tar.gz: SHA512 = 11B5B7A3 92705086 1D895D9B 3E27E926 D7E8A610
                                9622FFB5 ED6E8B2C 27721F96 6001D9EE 8334D9C5
                                E1553319 9FCA1B55 0FA4061A 0D746AE0 7F871BDD
                                9DB01B96
  '''
  ret = __salt__['http.query'](url)
  lines = ret['body'].split('\n')

  for line in lines:
    if 'SHA1' in line:
      checksum = ''.join(line.split()[3:]).lower()
      break
  else:
    return 'Checksum could not be found in {}'.format(url)

  return checksum
