    import sys
    import os
    import pprint
    import csv
    import importlib
    import pathlib


    def just_for_reddit(filename):
        if os.path.exists(filename) and os.path.isfile(filename):
            # ok let's open it and parse the data
            with open(filename, 'r') as csvfile:
                csvreader = csv.DictReader(
                        csvfile, delimiter=',',
                        doublequote=False, quotechar='"', dialect='excel',
                        escapechar='\\')
                data = []
                for rnum, row in enumerate(csvreader):
                    # pprint.pprint([rnum, row])
                    data.append(row)

                # load our memory footprint estimator code
                # 1: get cwd
                cwd = os.getcwd()
                # 2: set cwd to __file__
                module = 'size_of_object_recipe'
                sibpath = pathlib.Path(__file__).parent.absolute()
                os.chdir(sibpath)
                if os.path.exists(os.path.join(sibpath, module + '.py')) and \
                        os.path.isfile(os.path.join(sibpath, module + '.py')):
                    sizeofobj = importlib.import_module(module)
                    pprint.pprint(sizeofobj.asizeof(data))
                    pprint.pprint(csvfile.tell())
                else:
                    os.chdir(cwd)
                    raise Exception('module "{}" not found!'.format(
                        os.path.join(sibpath, module + '.py')))
        else:
            print('Invalid csv file: {}'.format(filename))


    if __name__ == '__main__':
        # get the filename from first argument
        filename = os.path.expanduser(sys.argv[1])
        just_for_reddit(filename)
