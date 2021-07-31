import math


class HeapPrinter:
    def __init__(self, val):
        self.val = val

    def to_string(self):
        prettier = list()
        cap_heap = self.val['capacity']
        for field in self.val.type.fields():
            field_name = field.name
            field_val = str(self.val[field_name])
            if field_name == "heap":
                heap_list = [str((self.val[field_name]+i).dereference())
                             for i in range(cap_heap)]
                depth = int(math.log2(cap_heap))

                pretty_heap = ""
                for dep in range(depth+1):
                    pretty_heap += '\t\t'*(depth-dep)
                    for elem in range(2**dep):
                        startidx = 2**dep-1
                        if elem + startidx >= cap_heap:
                            break
                        pretty_heap += heap_list[elem + startidx] + '\t\t'
                    pretty_heap += '\n\n'

                prettier.append(field_name + ' = ' + str(heap_list))
                prettier.append('prettier_' + field_name + ' ===> \n' + pretty_heap)
            else:
                if len(field_val.split(',')) > 1:
                    prettier.append(
                        field_name + ' = ' + '\n\t\t'.join(field_val.split(',')))
                else:
                    prettier.append(field_name + ' = ' + field_val)
        
        return '\n' + '\n'.join(prettier)


def custom_printer(val):
    if str(val.type) == 'VertexHeap':
        return HeapPrinter(val)


gdb.pretty_printers.append(custom_printer)
