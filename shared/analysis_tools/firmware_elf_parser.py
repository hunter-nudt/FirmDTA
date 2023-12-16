import sys
import os
import re
import subprocess
from subprocess import PIPE

def analyze_elf(file_path, output_file):
    try:
        result = subprocess.run(['readelf', '-a', file_path], stdout=PIPE, stderr=PIPE)
        output_file.write(file_path.encode())
        if(result.stdout.rstrip()):
            output_file.write(b'\n')
        output_file.write(result.stdout.rstrip())
        output_file.write(b'\n********\n')
    except Exception as e:
        print(f"Error analyzing {file_path}: {e}")

def traverse_folder(folder_path, output_file):
    for item in os.listdir(folder_path):
        item_path = os.path.join(folder_path, item)
        if os.path.isfile(item_path):
            analyze_elf(item_path, output_file)
        elif os.path.isdir(item_path):
            traverse_folder(item_path, output_file)

def symbol_extractor(parse_file, symbol_output_file):
    file_sym_info = parse_file.read().decode().split('\n********\n')
    for each_file_sym_info in file_sym_info:
        each_file_all_info = each_file_sym_info.split('\n\n')
        elf_head_info = each_file_all_info[0].split('\n')
        symbol_output_file.write(elf_head_info[0].encode())
        symbol_output_file.write(b'\n')
        for each_info_in_file in each_file_all_info:
            pattern1 = r"Symbol table"
            match_sym = re.search(pattern1, each_info_in_file)
            if match_sym:
                all_symbol_info = each_info_in_file.split('\n')
                for each_symbol_info in all_symbol_info[2:]:
                    symbol_element = re.split(r"\s+", each_symbol_info)      
                    symbol_output_file.write(symbol_element[2].encode() + b'\t')
                    symbol_output_file.write(symbol_element[3].encode() + b'\t')
                    symbol_output_file.write(symbol_element[8].encode())
                    symbol_output_file.write(b'\n')
        symbol_output_file.write(b'\n')
                
if __name__ == '__main__':
    folder_path = sys.argv[1]
    output_file_path = "output.txt"
    symbol_file = "symbol_table"
    with open(output_file_path, 'wb') as output_file:
        traverse_folder(folder_path, output_file)
    
    with open(output_file_path, 'rb') as parse_file:
        with open(symbol_file, 'wb') as symbol_output_file:
            symbol_extractor(parse_file, symbol_output_file)
