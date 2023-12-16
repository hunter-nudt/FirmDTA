#include "qemu/osdep.h"

typedef struct FrameHeader       /* 数据帧头 */
{
    uint8_t dst_MAC[6];         /* 目的MAC地址 */
    uint8_t src_MAC[6];         /* 源MAC地址 */
    uint16_t frame_type;        /* 帧类型 */
} FrameHeader;

typedef struct IPHeader         /* IP数据报头 */
{
    uint8_t version_header_len; /* 版本+报头长度 */
    uint8_t tos;                /* 服务类型 */
    uint16_t total_len;         /* 总长度 */
    uint16_t id;                /* 标识 */
    uint16_t flag_segment;      /* 标志+片偏移 */
    uint8_t TTL;                /* 生存周期 */
    uint8_t protocol;           /* 协议类型 */
    uint16_t checksum;          /* 头部校验和 */
    uint32_t src_IP;            /* 源IP地址 */
    uint32_t dst_IP;            /* 目的IP地址 */
} IPHeader;

typedef struct TCPHeader        /* TCP数据报头 */
{
    uint16_t src_port;          /* 源端口 */
    uint16_t dst_port;          /* 目的端口 */
    uint32_t seq_number;        /* 序号 */
    uint32_t ack_number;        /* 确认号 */
    uint8_t header_len;         /* 数据报头的长度(4 bit) + 保留(4 bit) */
    uint8_t flags;              /* 标识TCP不同的控制消息 */
    uint16_t window;            /* 窗口大小 */
    uint16_t checksum;          /* 校验和 */
    uint16_t urgent_pointer;    /* 紧急指针 */
} TCPHeader;

typedef struct MarkMsg
{
    char url[200];
    char label[50];
    uint32_t taint_start;
    uint32_t taint_len;
} MarkMsg;

extern MarkMsg mark_msg;

int match_http_data(uint8_t *data, uint8_t *url, int *http_head, int *http_len);
int match_taint_data(uint8_t *data, char *label, int *taint_head, int *taint_len);
int match_taint_data_ip110(uint8_t *data, int *taint_head, int *taint_len);