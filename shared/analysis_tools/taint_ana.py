#!/usr/bin/env python3
import re
import os
import sys
import networkx as nx
import matplotlib.pyplot as plt
import numpy as np

class taint_msg:
    def __init__(self):
        self.pc_base = ''
        self.ins_no = ''
        self.pid = ''
        self.current_pgd = ''
        self.proc_name = ''
        self.mod_name = ''
        self.mod_base = ''
        self.modsize = ''
        self.func_name = ''
        self.load_addr = []
        self.store_addr = []

class ins_msg:
    def __init__(self):
        self.ins_no = ''
        self.pid = ''
        self.current_pgd = ''
        self.proc_name = ''
        self.mod_name = ''
        self.mod_base = ''
        self.modsize = ''
        self.pc_base = ''
        self.blcok_size = ''
        self.func_name = ''

class symbol_file:
    def __init__(self):
        self.file_name = ''
        self.symbol_msg = []


class symbol_info:
    def __init__(self):
        self.func_base = 0
        self.func_size = 0
        self.func_name = ''
        
init_taint_addr_list = []
taint_data_flow = []
taint_data_flow_no = []
symbol_list = []
symbol_file_name_list = []
ins_flow = []

def load_taint_data(taint_file_path):
    with open(taint_file_path, 'rb') as f:
        blocks = f.read().decode().strip().split('\n\n')
        init_taint_addr_zone = blocks[0].split('\n')
        init_taint_addr = init_taint_addr_zone[1].split('\t')
        for each_addr in init_taint_addr:
            init_taint_addr_list.append(each_addr)
        for eachblock in blocks[1:]:
            lines = eachblock.split('\n')
            each_taint_msg = lines[0].split('\t')
            new_taint_msg = taint_msg()
            new_taint_msg.pc_base = each_taint_msg[7]
            new_taint_msg.ins_no = each_taint_msg[0]
            new_taint_msg.pid = each_taint_msg[1]
            new_taint_msg.current_pgd = each_taint_msg[2]
            new_taint_msg.proc_name = each_taint_msg[3]
            new_taint_msg.mod_name = each_taint_msg[4]
            new_taint_msg.mod_base = each_taint_msg[5]
            new_taint_msg.modsize = each_taint_msg[6]
            if int(each_taint_msg[7],16) > 0x70000000:
                offset = int(each_taint_msg[7],16) - int(each_taint_msg[5],16)
            else:
                offset = int(each_taint_msg[7],16)
            for i in range(len(symbol_file_name_list)):
                if each_taint_msg[4] == symbol_file_name_list[i]:
                    for j in range(len(symbol_list[i].symbol_msg)):
                        if offset >= symbol_list[i].symbol_msg[j].func_base:
                            if offset <= symbol_list[i].symbol_msg[j].func_base + symbol_list[i].symbol_msg[j].func_size:
                                new_taint_msg.func_name = symbol_list[i].symbol_msg[j].func_name
                                # print(new_taint_msg.pc_base,new_taint_msg.proc_name,new_taint_msg.func_name)
            
            for eachline in lines[1:]:
                taint_mem_msg = eachline.split('\t')
                if (len(taint_mem_msg) != 3):
                    break
                is_load = int(taint_mem_msg[0], 10)
                size = int(taint_mem_msg[2], 10)
                if is_load == 1:
                    for i in range(0,size):
                        addr = hex(int(taint_mem_msg[1], 16) + i)
                        new_taint_msg.load_addr.append(str(addr)) 
                        # print(new_taint_msg.load_addr)
                else:
                    for i in range(0,size):
                        addr = hex(int(taint_mem_msg[1], 16) + i)
                        new_taint_msg.store_addr.append(str(addr))  
            taint_data_flow.append(new_taint_msg)
            taint_data_flow_no.append(new_taint_msg.pc_base)
    print(taint_data_flow[len(taint_data_flow)-1].load_addr)

def load_symbol_info(symbol_file_path):
    with open(symbol_file_path,'rb') as symbol_file_handle:
        all_symbol_info = symbol_file_handle.read().decode('utf-8','ignore').split('\n\n')
        for all_file_symbol in all_symbol_info:
            all_symbol_lines = all_file_symbol.split('\n')
            new_symbol_file = symbol_file()
            new_symbol_file.file_name = all_symbol_lines[0]
            file_path = all_symbol_lines[0].split('/')
            sample_file_name = file_path[-1]
            symbol_file_name_list.append(sample_file_name)
            # print(new_symbol_file.file_name)
            for each_symbol_line in all_symbol_lines[1:]:
                symbol_element = each_symbol_line.split('\t')
                temp_symbol_info = symbol_info()
                try:
                    temp_symbol_info.func_base = int(symbol_element[0], 16)
                    temp_symbol_info.func_size = int(symbol_element[1], 10)
                    temp_symbol_info.func_name = symbol_element[2]
                    # print(temp_symbol_info.func_base,temp_symbol_info.func_size,symbol_element[2])
                except:
                    print('func error')
                new_symbol_file.symbol_msg.append(temp_symbol_info)
            symbol_list.append(new_symbol_file)
    symbol_file_name_list.pop()
    # print(hex(symbol_list[0].symbol_msg[1].func_base))
    # print(symbol_file_name_list[-1])

def load_ins_flow(ins_file_path):
    with open(ins_file_path,'rb') as ins_file_handle:
        all_ins_block = ins_file_handle.read().decode('utf-8','ignore').strip().split('\n\n')     
        for each_ins_block in all_ins_block:
            each_inss = each_ins_block.split('\n')
            # print(each_inss)
            ins_block_infos = each_inss[0].split('\t')
            # print(len(ins_block_infos))
            if len(ins_block_infos) < 9:
                continue
            new_ins_msg = ins_msg()
            new_ins_msg.ins_no = ins_block_infos[0]
            new_ins_msg.pid = ins_block_infos[1]
            new_ins_msg.current_pgd = ins_block_infos[2]
            new_ins_msg.proc_name = ins_block_infos[3]
            new_ins_msg.mod_name = ins_block_infos[4]
            new_ins_msg.mod_base = ins_block_infos[5]
            new_ins_msg.modsize = ins_block_infos[6]
            new_ins_msg.pc_base = ins_block_infos[7]
            new_ins_msg.blcok_size = ins_block_infos[8]
            ins_flow.append(new_ins_msg)
    # print(ins_flow[0].ins_no)

def find_src_func(taint_addr, index, src_pc_base):
    init_index = index
    while (index > 0):
        index = index - 1
        for i in range(len(taint_data_flow[index].store_addr)):
            if taint_data_flow[index].store_addr[i] == taint_addr:
                # print(taint_addr)                
                G.add_node(taint_data_flow[init_index], edgecolor = "#000000", data = taint_data_flow[init_index])                      
                G.add_node(taint_data_flow[index], edgecolor = "#000000", data = taint_data_flow[index])
                G.add_edge(taint_data_flow[init_index], taint_data_flow[index])
                if(len(taint_data_flow[index].load_addr) != 0):
                    for j in range(len(taint_data_flow[index].load_addr)):
                        find_src_func(taint_data_flow[index].load_addr[j], index, taint_data_flow[index].pc_base)

# G.add_edges_from(edges)

def search_taint_path():
    index = len(taint_data_flow) - 1
    for i in range(len(taint_data_flow[-1].load_addr)):
        taint_addr = taint_data_flow[-1].load_addr[i]
        init_pc_base = taint_data_flow[index].pc_base
        print(taint_addr)
        find_src_func(taint_addr, index, init_pc_base)
    for i in range(len(taint_data_flow[-1].load_addr)):
        G.add_node(taint_data_flow[index], edgecolor = "#FF9800", data = taint_data_flow[index])       
      
if __name__ == '__main__':  
    symbol_file_path = "symbol_extract"
    taint_file_path = "guest_taint_log"
    ins_file_path = "guest_ins_flow_log"
    load_symbol_info(symbol_file_path)
    load_ins_flow(ins_file_path)
    load_taint_data(taint_file_path)
    
    G = nx.DiGraph()

    fig = plt.figure(figsize=(8, 4), dpi=300)
    
    search_taint_path()
    
    nodes = G.nodes()
    
    node_labels = {}
    for node in G.nodes:
        if G.nodes[node]['data'].proc_name != G.nodes[node]['data'].mod_name:
            current_ins_no = int(G.nodes[node]['data'].ins_no, 10)
            for i in range(len(ins_flow)):
                if int(ins_flow[i].ins_no, 10) == current_ins_no:
                    current_ins_no_pre = i
                    current_ins_no_next = i
                    # print(current_ins_no_pre)
            while True:
                current_ins_no_pre = current_ins_no_pre - 1
                if ins_flow[current_ins_no_pre].proc_name == ins_flow[current_ins_no_pre].mod_name:
                    if ins_flow[current_ins_no_pre].proc_name == G.nodes[node]['data'].proc_name:
                        G.nodes[node]['data_prev'] = ins_flow[current_ins_no_pre]
                        for i in range(len(symbol_file_name_list)):
                            if ins_flow[current_ins_no_pre].mod_name == symbol_file_name_list[i]:
                                for j in range(len(symbol_list[i].symbol_msg)):
                                    if int(ins_flow[current_ins_no_pre].pc_base, 16) >= symbol_list[i].symbol_msg[j].func_base:
                                        if int(ins_flow[current_ins_no_pre].pc_base, 16) <= symbol_list[i].symbol_msg[j].func_base + symbol_list[i].symbol_msg[j].func_size:
                                            G.nodes[node]['data_prev'].func_name = symbol_list[i].symbol_msg[j].func_name
                        break
                
            while True:
                current_ins_no_next = current_ins_no_next + 1
                if ins_flow[current_ins_no_next].proc_name == ins_flow[current_ins_no_next].mod_name:
                    if ins_flow[current_ins_no_next].proc_name == G.nodes[node]['data'].proc_name:
                        G.nodes[node]['data_next'] = ins_flow[current_ins_no_next]
                        for i in range(len(symbol_file_name_list)):
                            if ins_flow[current_ins_no_next].mod_name == symbol_file_name_list[i]:
                                for j in range(len(symbol_list[i].symbol_msg)):
                                    if int(ins_flow[current_ins_no_next].pc_base, 16) >= symbol_list[i].symbol_msg[j].func_base:
                                        if int(ins_flow[current_ins_no_next].pc_base, 16) <= symbol_list[i].symbol_msg[j].func_base + symbol_list[i].symbol_msg[j].func_size:
                                            G.nodes[node]['data_next'].func_name = symbol_list[i].symbol_msg[j].func_name
                        break
        else:
            G.nodes[node]['data_prev'] = G.nodes[node]['data']
            G.nodes[node]['data_next'] = G.nodes[node]['data']
               
    for node in G.nodes:
        node_labels[node] = 'prev :' + G.nodes[node]['data_prev'].pc_base   \
                            + '\n' + G.nodes[node]['data_prev'].func_name   \
                            + '\n'  \
                            + '\nproc : ' + G.nodes[node]['data'].proc_name    \
                            + '\nmod : ' + G.nodes[node]['data'].mod_name    \
                            + '\npc_base : ' + G.nodes[node]['data'].pc_base    \
                            + '\nfunc : ' + G.nodes[node]['data'].func_name    \
                            + '\n'  \
                            + '\nnext :' + G.nodes[node]['data_next'].pc_base   \
                            + '\n' + G.nodes[node]['data_next'].func_name
        # print('prev :' + G.nodes[node]['data_prev'].pc_base   \
        #     + '\n' + G.nodes[node]['data_prev'].func_name   \
        #     + '\n'  \
        #     + '\nproc : ' + G.nodes[node]['data'].proc_name    \
        #     + '\nmod : ' + G.nodes[node]['data'].mod_name    \
        #     + '\npc_base : ' + G.nodes[node]['data'].pc_base    \
        #     + '\nfunc : ' + G.nodes[node]['data'].func_name    \
        #     + '\n'  \
        #     + '\nnext :' + G.nodes[node]['data_next'].pc_base   \
        #     + '\n' + G.nodes[node]['data_next'].func_name)
    
    
    
    edge_colors = [G.nodes[node]["edgecolor"] for node in G.nodes]
    edge_colors[1] = "#FF0000"
    edge_colors[-1] = "#00FF00"
    
    options = {
        "node_color": "#FFFFFF",
        # "edgecolors": "#000000",
        "node_size": 3500,
        "width": 1,
        # "cmap": plt.cm.Blues,
        # "edge_cmap": plt.cm.Blues,
        "node_shape": 'o',  #so^>v<dph8
        "with_labels": False,
        "arrowsize": 12,
        "arrowstyle": '-|>',
    }
    
    np.random.seed(20)

    pos = nx.shell_layout(G)
    
    nx.draw(G, pos, **options, edgecolors = edge_colors)
    
    nx.draw_networkx_labels(G, pos, labels=node_labels, font_color="#000000", font_size=4, font_family="Arial Rounded MT Bold")
    
    ax = plt.gca()

    ax.margins(0.10)
     
    plt.axis('off')
    
    plt.savefig("taint_data_flow.svg", format="svg")
    # plt.tight_layout()
    plt.show()