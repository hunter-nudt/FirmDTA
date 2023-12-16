#include "shared/fdta-linux-procinfo.h"
#include "shared/fdta-main.h"
#include "shared/fdta-linux-vmi.h"
#include "shared/fdta-vmi-common.h"
#include "shared/fdta-callback-common.h"
#include "shared/fdta-target.h"

#include <unordered_map>
#include <unordered_set>
#include <vector>
using namespace std;

#include <boost/foreach.hpp>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/ini_parser.hpp>
#include <boost/lexical_cast.hpp>


int is_kernel_address_or_null(gva_t addr)
{
    return ((addr == (gva_t)0) || (is_kernel_address(addr))); 
}

int is_struct_kernel_address(gva_t addr, uint32_t structSize)
{
    return (is_kernel_address(addr) && is_kernel_address(addr + structSize));
}

// The idea is to go through the data structures and find an
// item that points back to the threadinfo
// ASSUMES PTR byte aligned
// gva_t find_taskstruct_from_threadinfo(CPUState * cs, gva_t threadinfo, ProcInfo* pPI, int bDoubleCheck) __attribute__((optimize("O0")));
gva_t find_taskstruct_from_threadinfo(CPUState * cs, gva_t threadinfo, ProcInfo* pPI)
{
    uint32_t i = 0;
    uint32_t j = 0;
    gva_t temp = 0;
    gva_t temp2 = 0;
    gva_t candidate = 0;
    gva_t ret = INV_ADDR;
    
    if (pPI == NULL)
    {
        return (INV_ADDR);
    }
    
    if (is_kernel_address(threadinfo))
    {
        //iterate through the thread info structure
        for (i = 0; i < MAX_THREAD_INFO_SEARCH_SIZE; i+= sizeof(target_ptr))
        {
            temp = (threadinfo + i);
            candidate = 0;
            fdta_read_ptr(cs, temp, &candidate);
            //if it looks like a kernel address
            if (is_kernel_address(candidate))
            {
            //iterate through the potential task struct 
                for (j = 0; j < MAX_TASK_STRUCT_SEARCH_SIZE; j+= sizeof(target_ptr))
                {
                    temp2 = (candidate + j);
                    //if there is an entry that has the same 
                    // value as threadinfo then we are set
                    uint32_t val = 0;
                    fdta_read_ptr(cs, temp2, &val);
                    if (val == threadinfo)
                    {
                        pPI->ti_task = i;
                        pPI->ts_stack = j;
                        ret = candidate;
                        return ret;
                    }
                }
            }
        }   
    }
    
    return ret;
}


void get_executable_directory(string &sPath)
{
    int rval;
    char szPath[1024];
    sPath = "";
    rval = readlink("/proc/self/exe", szPath, sizeof(szPath)-1);
    if(-1 == rval)
    {
        printf("can't get path of main executable.\n");
        return;
    }
    szPath[rval-1] = '\0';
    sPath = szPath;
    sPath = sPath.substr(0, sPath.find_last_of('/'));
    sPath += "/";
    return;
}

void get_procinfo_directory(string &sPath)
{
    get_executable_directory(sPath);
    sPath += "../shared/kernelinfo/procinfo_generic/";
    return;
}

// given the section number, load the offset values
#define FILL_fdta_target_ulong_FIELD(field) pi.field = pt.get(sSectionNum + #field, INVALID_VAL)
void load_one_section(const boost::property_tree::ptree &pt, int iSectionNum, ProcInfo &pi)
{
    string sSectionNum;

    sSectionNum = boost::lexical_cast<string>(iSectionNum);
    sSectionNum += ".";

    // fill strName field
    string sName;
    const int SIZE_OF_STR_NAME = 32;
    sName = pt.get<string>(sSectionNum + "strName");
    strncpy(pi.strName, sName.c_str(), SIZE_OF_STR_NAME);
    pi.strName[SIZE_OF_STR_NAME-1] = '\0';

    const fdta_target_ulong INVALID_VAL = -1;

    // fill other fields
    FILL_fdta_target_ulong_FIELD(init_task_addr  );
    FILL_fdta_target_ulong_FIELD(init_task_size  );
    FILL_fdta_target_ulong_FIELD(ts_tasks        );
    FILL_fdta_target_ulong_FIELD(ts_pid          );
    FILL_fdta_target_ulong_FIELD(ts_tgid         );
    FILL_fdta_target_ulong_FIELD(ts_group_leader );
    FILL_fdta_target_ulong_FIELD(ts_thread_group );
    FILL_fdta_target_ulong_FIELD(ts_real_parent  );
    FILL_fdta_target_ulong_FIELD(ts_mm           );
    FILL_fdta_target_ulong_FIELD(ts_stack        );
    FILL_fdta_target_ulong_FIELD(ts_real_cred    );
    FILL_fdta_target_ulong_FIELD(ts_cred         );
    FILL_fdta_target_ulong_FIELD(ts_comm         );

	FILL_fdta_target_ulong_FIELD(modules         );
	FILL_fdta_target_ulong_FIELD(module_name     );
	FILL_fdta_target_ulong_FIELD(module_init     );
	FILL_fdta_target_ulong_FIELD(module_size     );
	FILL_fdta_target_ulong_FIELD(module_list     );
			    
    FILL_fdta_target_ulong_FIELD(cred_uid        );
    FILL_fdta_target_ulong_FIELD(cred_gid        );
    FILL_fdta_target_ulong_FIELD(cred_euid       );
    FILL_fdta_target_ulong_FIELD(cred_egid       );
    FILL_fdta_target_ulong_FIELD(mm_mmap         );
    FILL_fdta_target_ulong_FIELD(mm_pgd          );
    FILL_fdta_target_ulong_FIELD(mm_arg_start    );
    FILL_fdta_target_ulong_FIELD(mm_start_brk    );
    FILL_fdta_target_ulong_FIELD(mm_brk          );
    FILL_fdta_target_ulong_FIELD(mm_start_stack  );
    FILL_fdta_target_ulong_FIELD(vma_vm_start    );
    FILL_fdta_target_ulong_FIELD(vma_vm_end      );
    FILL_fdta_target_ulong_FIELD(vma_vm_next     );
    FILL_fdta_target_ulong_FIELD(vma_vm_file     );
    FILL_fdta_target_ulong_FIELD(vma_vm_flags    );
    FILL_fdta_target_ulong_FIELD(vma_vm_pgoff    );
    FILL_fdta_target_ulong_FIELD(file_dentry     );
	FILL_fdta_target_ulong_FIELD(file_inode		);
    FILL_fdta_target_ulong_FIELD(dentry_d_name   );
    FILL_fdta_target_ulong_FIELD(dentry_d_iname  );
    FILL_fdta_target_ulong_FIELD(dentry_d_parent );
    FILL_fdta_target_ulong_FIELD(ti_task         );
	FILL_fdta_target_ulong_FIELD(inode_ino);

	FILL_fdta_target_ulong_FIELD(proc_fork_connector);
	FILL_fdta_target_ulong_FIELD(proc_exit_connector);
	FILL_fdta_target_ulong_FIELD(proc_exec_connector);
	FILL_fdta_target_ulong_FIELD(vma_link);
	FILL_fdta_target_ulong_FIELD(remove_vma);
	FILL_fdta_target_ulong_FIELD(vma_adjust);

	FILL_fdta_target_ulong_FIELD(trim_init_extable);
#ifdef TARGET_MIPS
    FILL_fdta_target_ulong_FIELD(mips_pgd_current);
#endif
}

// find the corresponding section for the current os and return the section number
int find_match_section(const boost::property_tree::ptree &pt, fdta_target_ulong tulInitTaskAddr)
{
    int cntSection = pt.get("info.total", 0);

    string sSectionNum;
    vector<int> vMatchNum;

    printf("Total Sections: %d\n", cntSection);

    for(int i = 1; i<=cntSection; ++i)
    {
        sSectionNum = boost::lexical_cast<string>(i);
        fdta_target_ulong tulAddr = pt.get<fdta_target_ulong>(sSectionNum + ".init_task_addr");
        if(tulAddr == tulInitTaskAddr)
        {
            vMatchNum.push_back(i);
        }
    }

    if(vMatchNum.size() > 1)
    {
        printf("Too many match sections in procinfo.ini\n");
        return 0;
    }
    
    if(vMatchNum.size() <= 0)
    {
        printf("No match in procinfo.ini\n");
        return 0;        
    }

    return vMatchNum[0];
}


// infer init_task_addr, use the init_task_addr to search for the corresponding
// section in procinfo.ini. If found, fill the fields in ProcInfo struct.
int load_proc_info(CPUState *cs, gva_t threadinfo, ProcInfo &pi)
{
    static bool bProcinfoMisconfigured = false;
    const int CANNOT_FIND_INIT_TASK_STRUCT = -1;
    const int CANNOT_OPEN_PROCINFO = -2;
    const int CANNOT_MATCH_PROCINFO_SECTION = -3;
    gva_t tulInitTaskAddr = INV_ADDR;

    if(bProcinfoMisconfigured)
    {
        return CANNOT_MATCH_PROCINFO_SECTION;
    }

    // find init_task_addr
    tulInitTaskAddr = find_taskstruct_from_threadinfo(cs, threadinfo, &pi);
    
    // tulInitTaskAddr = 2154330880;
    if (tulInitTaskAddr == INV_ADDR)
    {
        return CANNOT_FIND_INIT_TASK_STRUCT;
    }

    string sProcInfoPath;
    boost::property_tree::ptree pt;
    get_procinfo_directory(sProcInfoPath);
    sProcInfoPath += "procinfo.ini";
    printf("\nProcinfo path: %s\n",sProcInfoPath.c_str());
    // read procinfo.ini
    if (0 != access(sProcInfoPath.c_str(), 0))
    {
        printf("can't open %s\n", sProcInfoPath.c_str());
        return CANNOT_OPEN_PROCINFO;
    }
    boost::property_tree::ini_parser::read_ini(sProcInfoPath, pt);

    // find the match section using previously found init_task_addr
    int iSectionNum = find_match_section(pt, tulInitTaskAddr);
    // no match or too many match sections
    if(0 == iSectionNum)
    {
        printf("VMI won't work.\nPlease configure procinfo.ini and restart FDTAF.\n");
        // exit(0);
        bProcinfoMisconfigured = true;
        return CANNOT_MATCH_PROCINFO_SECTION;
    }

    load_one_section(pt, iSectionNum, pi);
    printf("Match %s\n", pi.strName);
    return 0;
}

class LibraryLoader
{
public:
    LibraryLoader(const char *strName)
    {
        if(init_property_tree(strName))
        {
            load();
        }
    }
private:
    bool init_property_tree(const char* strName)
    {
        string sLibConfPath;
        get_procinfo_directory(sLibConfPath);
        const string LIB_CONF_DIR = "lib_conf/";
        sLibConfPath = sLibConfPath + LIB_CONF_DIR + strName + ".ini";

        if (0 != access(sLibConfPath.c_str(), 0))
        {
            printf("\nCan't open %s\nLibrary function offset will not be loaded.\nGo head if you don't need to hook library functions.\n", sLibConfPath.c_str());
            return false;
        }

        boost::property_tree::ini_parser::read_ini(sLibConfPath, m_pt);
        return true;
    }


    void load()
    {
        // load every section
        int cntSection = m_pt.get("info.total", 0);
        string sSectionNum;

        printf("Lib Configuration Total Sections: %d\n", cntSection);

        for(int i = 1; i<=cntSection; ++i)
        {
            sSectionNum = boost::lexical_cast<string>(i);
            m_cur_libpath = m_pt.get<string>(sSectionNum + "." + LIBPATH_PROPERTY_NAME);
            m_cur_section = &m_pt.get_child(sSectionNum);
            load_cur_section();
        }
    }

    void load_cur_section()
    {
        printf("loading lib conf for %s\n", m_cur_libpath.c_str());
        // traverse the section
        BOOST_FOREACH(boost::property_tree::ptree::value_type &v, *m_cur_section)
        {
            if(!v.first.compare(LIBPATH_PROPERTY_NAME))
            {
                continue;
            }
            // insert function
            // fdta_target_ulong addr = m_cur_section->get<fdta_target_ulong>(v.first);
            // funcmap_insert_function(m_cur_libpath.c_str(), v.first.c_str(), addr, 0);
        }
    }

    boost::property_tree::ptree m_pt;
    string m_cur_libpath;
    boost::property_tree::ptree *m_cur_section;
public:
    static const string LIBPATH_PROPERTY_NAME;
};

const string LibraryLoader::LIBPATH_PROPERTY_NAME = "fdta_conf_libpath";

void load_library_info(const char *strName)
{
    LibraryLoader loader(strName);
}

int print_proc_info(ProcInfo* pPI)
{
    if (pPI == NULL)
    {
        return (-1);
    }

    printf("entry name:%s\n",pPI->strName);
    printf("init_task address:%x\n",pPI->init_task_addr);
    printf("size of task_struct:%d\n",pPI->init_task_size);
    printf("offset of task_struct list:%d\n",pPI->ts_tasks);
    printf("offset of pid:%d\n",pPI->ts_pid);
    printf("offset of tgid:%d\n",pPI->ts_tgid);
    printf("offset of group_leader:%d\n",pPI->ts_group_leader);
    printf("offset of thread_group:%d\n",pPI->ts_thread_group);
    printf("offset of real_parent:%d\n",pPI->ts_real_parent);
    printf("offset of mm:%d\n",pPI->ts_mm);
    printf("offset of stack:%d\n",pPI->ts_stack);
    printf("offset of real_cred:%d\n",pPI->ts_real_cred);
    printf("offset of cred:%d\n",pPI->ts_cred);
    printf("offset of comm:%d\n",pPI->ts_comm);
    printf("size of comm:%d\n",SIZEOF_COMM);
    printf("inode index number:%d\n",pPI->inode_ino);


    printf("offset of uid cred:%d\n",pPI->cred_uid);
    printf("offset of gid cred:%d\n",pPI->cred_gid);
    printf("offset of euid cred:%d\n",pPI->cred_euid);
    printf("offset of egid cred:%d\n",pPI->cred_egid);
    

    printf("offset of mmap in mm:%d\n",pPI->mm_mmap);
    printf("offset of pgd in mm:%d\n",pPI->mm_pgd);
    printf("offset of arg_start in mm:%d\n",pPI->mm_arg_start);
    printf("offset of start_brk in mm:%d\n",pPI->mm_start_brk);
    printf("offset of brk in mm:%d\n",pPI->mm_brk);
    printf("offset of start_stack in mm:%d\n",pPI->mm_start_stack);
    

    printf("offset of vm_start in vma:%d\n",pPI->vma_vm_start);
    printf("offset of vm_end in vma:%d\n",pPI->vma_vm_end);
    printf("offset of vm_next in vma:%d\n",pPI->vma_vm_next);
    printf("offset of vm_file in vma:%d\n",pPI->vma_vm_file);
    printf("offset of vm_flags in vma:%d\n",pPI->vma_vm_flags);
    

    printf("offset of dentry in file:%d\n",pPI->file_dentry);
    printf("offset of d_name in dentry:%d\n",pPI->dentry_d_name);
    printf("offset of d_iname in dentry:%d\n",pPI->dentry_d_iname);
    printf("offset of d_parent in dentry:%d\n",pPI->dentry_d_parent);
    

    printf("offset of task in thread info:%d\n",pPI->ti_task);

    return (0);
}