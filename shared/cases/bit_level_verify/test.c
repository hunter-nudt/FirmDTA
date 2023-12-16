/*=====================================================================
cgi例子
=====================================================================*/
//pass.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* getcgidata(FILE* fp, char* requestmethod);

int main(void)
{
    char static_pass[64] = {0x20,0x22,0x22,0x24,0x24,0x26};
    char *input;
    char *req_method;
    char name[64];
    char pass[64];
    char encrypto_name[64];
    char encrypto_pass[64];
    int i = 0;
    int j = 0;
    char snt_code[64];

    memset(snt_code,0xee,63);
    
//     printf("Content-type: text/plain; charset=iso-8859-1\n\n");
    printf("Content-type: text/html\n\n");
    printf("The following is query reuslt:<br><br>");
    req_method = getenv("REQUEST_METHOD");
    input = getcgidata(stdin, req_method);
    // 我们获取的input字符串可能像如下的形式
    // Username="admin"&Password="aaaaa"
    // 其中"Username="和"&Password="都是固定的
    // 而"admin"和"aaaaa"都是变化的，也是我们要获取的
    
    // 前面9个字符是UserName=
    // 在"UserName="和"&"之间的是我们要取出来的用户名
    for ( i = 9; i < (int)strlen(input); i++ )
    {
        if ( input[i] == '&' )
        {
                name[j] = '\0';
                break;
        }                  
        name[j++] = input[i];
    }
    // 前面9个字符 + "&Password="10个字符 + Username的字符数
    // 是我们不要的，故省略掉，不拷贝
    for ( i = 19 + strlen(name), j = 0; i < (int)strlen(input); i++ )
    {
        pass[j++] = input[i];
    }
    pass[j] = '\0';

    for (i = 0;i < strlen(name);i++)
    {
        encrypto_name[i] = name[i] & snt_code[i];  
    }

    for (i = 0;i < strlen(pass);i++)
    {
        encrypto_pass[i] = pass[i] & snt_code[i];
    }

    if(!memcmp(static_pass,encrypto_pass,6))
    {
        printf("Your Username is %s<br>Your Password is %s<br> \n", name, pass);
    }
    else
    {
        printf("wrong pass!\n");
    }
    
    return 0;
}

char* getcgidata(FILE* fp, char* requestmethod)
{
    char* input;
    int len;
    int size = 1024;
    int i = 0;
    
    if (!strcmp(requestmethod, "GET"))
    {
            input = getenv("QUERY_STRING");
            return input;
    }
    else if (!strcmp(requestmethod, "POST"))
    {
            len = atoi(getenv("CONTENT_LENGTH"));
            input = (char*)malloc(sizeof(char)*(size + 1));
            
            if (len == 0)
            {
                    input[0] = '\0';
                    return input;
            }
            
            while(1)
            {
                    input[i] = (char)fgetc(fp);
                    if (i == size)
                    {
                        input[i+1] = '\0';
                        return input;
                    }
                
                    --len;
                    if (feof(fp) || (!(len)))
                    {
                        i++;
                        input[i] = '\0';
                        return input;
                    }
                    i++;         
            }
    }
    return NULL;
}
