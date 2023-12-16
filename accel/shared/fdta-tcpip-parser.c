#include "qemu/osdep.h"
#include "shared/fdta-types-common.h"
#include <netinet/in.h>
#include "shared/fdta-tcpip-parser.h"

MarkMsg mark_msg;

int match_http_data(uint8_t *data, uint8_t *url, int *http_head, int *http_len)
{
	uint8_t *data_ptr;
	FrameHeader *frame_header;
	IPHeader *ip_header;
	TCPHeader *tcp_header;
	int ip_len;
	uint8_t ip_proto;
	int http_len_t;
	int http_head_t;
    int i = 0;

	data_ptr = data;
	frame_header = (FrameHeader *)malloc(sizeof(FrameHeader));
	ip_header = (IPHeader *)malloc(sizeof(IPHeader));
	tcp_header = (TCPHeader *)malloc(sizeof(TCPHeader));

	memcpy(frame_header, data_ptr, sizeof(FrameHeader));
	data_ptr += sizeof(FrameHeader);
	memcpy(ip_header, data_ptr, sizeof(IPHeader));
	data_ptr += sizeof(IPHeader);
	memcpy(tcp_header, data_ptr, sizeof(TCPHeader));
	data_ptr += sizeof(TCPHeader);

	ip_proto = ip_header->protocol;
	if(ip_proto != 0x06) {
		return 0;
	}

	ip_len = ntohs(ip_header->total_len);
	http_len_t = ip_len - 40;
	http_head_t = 54;

	while (http_len_t != 0)
	{
		if (data_ptr[0] == 0x4F || data_ptr[0] == 0x48 || 
			data_ptr[0] == 0x43 || data_ptr[0] == 0x47 || 
			data_ptr[0] == 0x50 || data_ptr[0] == 0x44 ||
			data_ptr[0] == 0x54) {
			if (!strncmp((char *)data_ptr, "GET", 3) ||
				!strncmp((char *)data_ptr, "POST", 4) ||
				!strncmp((char *)data_ptr, "HEAD", 4) ||
				!strncmp((char *)data_ptr, "PUT", 3) ||
				!strncmp((char *)data_ptr, "OPTIONS", 7) ||
				!strncmp((char *)data_ptr, "DELETE", 6) ||
				!strncmp((char *)data_ptr, "TRACE", 5) ||
				!strncmp((char *)data_ptr, "CONNECT", 7)) {
				*http_head = http_head_t;
				*http_len = http_len_t;
				while (data_ptr[0] != 0x20) {
					data_ptr++;
				}
				data_ptr++;
				while (data_ptr[i] != 0x20 && data_ptr[i] != 0x3F) {
					url[i] = data_ptr[i];
                    i++;
				}
				return 1;
			}
			else {
				data_ptr++;
				http_len_t--;
				http_head_t++;
			}
		}
		else {
			data_ptr++;
			http_len_t--;
			http_head_t++;
		}
	}
	return 0;
}

int match_taint_data(uint8_t *data, char *label, int *taint_head, int *taint_len)
{
    uint8_t *data_ptr;
	FrameHeader *frame_header;
	IPHeader *ip_header;
	TCPHeader *tcp_header;
	int ip_len;
	int taint_len_t;
	int taint_head_t;

	data_ptr = data;
	frame_header = (FrameHeader *)malloc(sizeof(FrameHeader));
	ip_header = (IPHeader *)malloc(sizeof(IPHeader));
	tcp_header = (TCPHeader *)malloc(sizeof(TCPHeader));

	memcpy(frame_header, data_ptr, sizeof(FrameHeader));
	data_ptr += sizeof(FrameHeader);
	memcpy(ip_header, data_ptr, sizeof(IPHeader));
	data_ptr += sizeof(IPHeader);
	memcpy(tcp_header, data_ptr, sizeof(TCPHeader));
	data_ptr += sizeof(TCPHeader);

	ip_len = ntohs(ip_header->total_len);
	taint_len_t = ip_len - 40;
	taint_head_t = 54;

    while (taint_len_t != 0)
	{
        if (data_ptr[0] == label[0] && data_ptr[1] == label[1]) {
            if (!strncmp((char *)data_ptr, label, strlen(label))) {
                *taint_head = taint_head_t + strlen(label);
				*taint_len = taint_len_t - strlen(label);
                return 1;
            }
            else {
                data_ptr++;
				taint_len_t--;
				taint_head_t++;
            }
        }
        else {
            data_ptr++;
            taint_len_t--;
            taint_head_t++;
        }
    }
    return 0;
}

int match_taint_data_ip110(uint8_t *data, int *taint_head, int *taint_len)
{
    uint8_t *data_ptr;
	FrameHeader *frame_header;
	IPHeader *ip_header;
	TCPHeader *tcp_header;
	int ip_len;
	int taint_len_t;
	int taint_head_t;

	data_ptr = data;
	frame_header = (FrameHeader *)malloc(sizeof(FrameHeader));
	ip_header = (IPHeader *)malloc(sizeof(IPHeader));
	tcp_header = (TCPHeader *)malloc(sizeof(TCPHeader));

	memcpy(frame_header, data_ptr, sizeof(FrameHeader));
	data_ptr += sizeof(FrameHeader);
	memcpy(ip_header, data_ptr, sizeof(IPHeader));
	data_ptr += sizeof(IPHeader);
	memcpy(tcp_header, data_ptr, sizeof(TCPHeader));
	data_ptr += sizeof(TCPHeader);

	ip_len = ntohs(ip_header->total_len);
	taint_len_t = ip_len - 40;
	taint_head_t = 54;

    while (taint_len_t != 0)
	{
        if (data_ptr[0] == 0x6C && data_ptr[1] == 0x61) {
            if (!strncmp((char *)data_ptr, "languse=", 8)) {
                *taint_head = taint_head_t + 8;
				*taint_len = taint_len_t - 8;
                return 1;
            }
            else {
                data_ptr++;
				taint_len_t--;
				taint_head_t++;
            }
        }
        else {
            data_ptr++;
            taint_len_t--;
            taint_head_t++;
        }
    }
    return 0;
}
