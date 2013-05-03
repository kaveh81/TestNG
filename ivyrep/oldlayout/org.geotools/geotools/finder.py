import sys, os

def do_or_die(cmd):
	print cmd
	if os.system(cmd) != 0:
		print 'failed'
		sys.exit(1)

files = [x.strip() for x in os.popen('find geotools-2.7-M1 -name "*.java" ').readlines()]
for clazz in sys.stdin.readlines():
	clazz = clazz.strip()
	clazz = clazz[:clazz.rfind('.')]
	for f in files:
		idx = f.find(clazz + '.java')
		if idx >= 0:
			tonextslash = f.find('/', idx)
			lastslash = f.rfind('/')
			do_or_die('mkdir -p tmp/%s' % f[idx:lastslash])
			do_or_die('cp %s tmp/%s' % (f, f[idx:lastslash]))
	
	
