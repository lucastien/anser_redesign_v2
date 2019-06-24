#ifndef DATA_H
#define DATA_H

#include <QMap>
#include <QVector>
#include <stdio.h>
#include <string.h>

/**************************************************************
*                                                             *
*             CHANNEL PARAMETERS                              *
*                                                             *
**************************************************************/
#define UNDEFINED_TESTER -256

#define OMNI200_T     -5
#define TC7700_T	-4
#define T_SIM_T		-3
#define TC6700_T	-2
#define MIZ18_T		0
#define MIZ18A_T		-1
#define MIZ30MHI_T	1
#define MIZ30Z_T		2
#define MIZ70Z_T		3
#define MIZ80_T      4

#define W_PARSE	(1<<0) //Parse data format type

#define W_ANSER_8_0	6700
#define W_ANSER_8_1	6701
#define W_ANSER_8_2	6702
#define SIZE_OF_82_81_HEADER  23552
#define SIZE_OF_82_81_COMMMON_TO_84  3072
#define SIZE_OF_82_81_CHAN_ORDER  1024
#define SIZE_OF_82_81_CHAN_INFO  8192
#define SIZE_OF_80_TESTER_CONFIGURATION_DATA  9216 /* 9K */
#define SIZE_OF_82_81_TESTER_CONFIGURATION_DATA  12288  /* 12K */

#define W_ANSER_8_3	6770 /* support both TC6700 tester and Miz70 tester */
#define W_ANSER_8_4	67701 /* support both TC6700 tester and Miz70 tester with expanded channel structure for MHI and X probe */
#define FALL_04 84100 /* data version that is created in Fall 04 contain additional info from acquisition
- Inspection Type
- AcqDirection
- EcTestInfo
  */
#define FALL_07 84300 /* data version that is created in Fall 07 contain additional info */
#define SETUP_8_01_TABLE_SIZE	4096 //nbytes of setup table 8_01
#define SETUP_8_01_TABLE_SIZE_EXTEND	1048576 /*SMS|Christian - 2017/06/22 03:07 PM | tms#16803 */

#define MAX_FREQ_ANSER	8    /* do not change used in tube header */

#define MAX_CHAN_OLD    256
#define MAX_CHAN 	320     /* do not change used in tube header */
#define MAX_CHAN_X 	320     /* do not change used in tube header W8_4 or later for Xprobe */
#define MAX_CHAN_CHAR	40	/* do not change used in tube header */
#define MAX_CONFIG	350
#define MaxConfigName   64      /* do not change used in tube header */


/*SMS|Cole - 2018/11/16 04:59 PM | tms#20201 */
//move to *.h file to reuse some places
#define NPT_CHUNK		5000
#define MIN_NPT			10000
//End Cole


#define MAX_DEG_PNTS		3   /* do not change used in setup header */
#define MAX_VOL_PNTS		3   /* do not change used in setup header */
#define MAX_CURVE_PNTS		5   /* do not change used in setup header */

#define GET_INT(p,off)		(*(int *) &(p)[(off)])
#define GET_SHORT(p,off)	(*(short *) &(p)[(off)])
#define GET_CHAR(p,off)		(*(char *) &(p)[(off)])
#define GET_FLOAT(p,off)	(*(float *) &(p)[(off)])
#define GET_DOUBLE(p,off)	(*(double *) &(p)[(off)])

#define MAX_CONVENTIONAL_PROBE_NCHAN 82  //define that conventional probe nchan is MHI of 80 channel or less - would be overlay with Miz70 - logical channel
//Somotsoft Team | 01/20/2015 2:41:02 PM | Johnnie.Lanh.Pham - https://tms.somotsoft.com/issues/8078 //
#define MAX_BOBBIN_CHAN				40
// End Johnnie.Lanh.Pham

/*SMS|Cole - 2016/03/30 01:59 PM | tms# move from file CoilDisp.Cpp */
#define MAX_CONVENTIONAL_PRB_NCHAN      64

// SMS-Christian TMS#13502
#define MAX_FLAW_IN_SETUP_TABLE				10
#define MAX_CHAN_PER_FLAW_IN_SETUP_TABLE	5

#define MAX_CHANNELS_PREDEFINED_CURVE	5
#define MAX_POINTS_PREDEFINED_CURVE		10
#define MAX_CURVE_FILE_NAME_LENGHT		50
/*SMS|Christian - 2017/06/21 05:29 PM | tms#16803 */
#define MAX_MIX_ALFS_CHAN	80
#define MAX_XT_COEF			861		/* [861] Xt x X array (symmetric matrix) (41,41) */
#define MAX_COEF			82              /* 20 * nft + 2 */
#define MIZ70_MAX_FREQS 32
#define READ_SIZE  32 * 1024

/* tape drive structures */
#define DATA_IDENT 		0x55550200
#define MESSAGE_IDENT	0x55550300
#define READ_CHECK		0
#define HEADER_END 		0xffffffff

#define BLOCK				1024
#define INQ_BUS_ADDRESS		7


#define SIZE_STATUS_REPORT 20    /* number of bytes in status report */

class Channel;

typedef struct {
    short num;		/* channel number 			0 */
    short freq;		/* frequency of this channel 		2 */
    short span;		/* Zetec span 				4 */
    short rot;		/* rotation 				6 */
    short coil;		/* coil number 				8 */

    /* new */
    short coil_group;       /* coil_group 				10 */
    short chan_mode;        /* 0= ABS, 1=DIF, 2=TRIG 		12 */
    short context;		/** time slot 				14 */
    char chan_name[16];	/* channel name                         16 */
} ChannelInfo;                  /* total size 32 bytes 			   */



typedef struct {
    int freq;
    unsigned coil;
} TestFreq_82;

typedef struct {
    int freq;
    int coil;
} TestFreq;


#define MaxTest 8 /* SMS|Christian - 2019/05/27 11:13 AM | tms#20848 */
#define LandmarkNameLen 4

typedef struct {
char landmark[LandmarkNameLen];  /* ex 3H, AVB4, TTS; does not include the offset */
    float specifiedOffset;   /* ex 3.0, -2.5 */
    } EcTestExtent; /* size 8 bytes */

typedef struct {
    float axial_speed;
    int rotation_speed;
    EcTestExtent startScan, endScan;
    EcTestExtent startAcquire, endAcquire; /* expanded location if a landmark not specified in
                                             area defined by startScan, endScan.  this is the
                                         freespan area where we acquire (only spin in the
                                         inner range).  same for non-freespan tests */
    } EcTestInfo;

typedef struct sTubeHeader{
    int data_ident;		/* 55550200				   0 */
    long tic_time;		/* utime 				   4 */
    long header_size;    	/* total size of header	in bytes	   8
                   TC6700 = 20480
                   TC6701 = 23552
                    TC6700 & Miz70 support MHI and X probe = 40K
                    */
    int id;			/* tube identification 			  12 */
    int  row;		/* 					  16 */
    int  col;		/*					  20 */
    char id_name[4];	/* tube id labels 			  24 */
    char row_name[4];	/*					  28 */
    char col_name[4];	/*					  32 */
    char free_space1[20];	/*					  36 */
    int delay;		/* delay between samples in uSecs 	  56 */
    short nParReg;		/* n region of parsing used for ParMask and ParReg 60 */
    char	samples_per_in;	/*							62*/
    char xHeaderFlag;	/* 	'X' if XML header present		  63 */
    unsigned int xHeaderLoc;/* byte offest from start of file to XML header following end of Data	64 */
    short trig_channel; /* trigger channel 68 */
    short probe_num;		/* probe number per Zetec req start from 1    70 */
    int num_probes;		/* number of probes 			  72 */
    int nchan;		/* number of channels 			  76 */
    int nbyte;		/* number of bytes in a sample 		  80 */
    char free_space3[72];	/* start of zetec fields 		  84 */
    char ztec_slew_time[8];	/* Double not aligned an 8 byte boundry  156 */
    char ParMask[48];		/* parsing mask for ParReg of size 48 below  164 */
    int ProbeType; /*                                212 */
    int Inspection_Type; /*                          216 */
    int AcqDirection; /*                             220 */
    int AcqFlags; /*                                 224 */
    int base_chan_offset; /*                            228*/
    char free_space4[146] ; /*                            232*/
    char comment[32];	/* comment text				 378 */
    char pr_name[14];	/* probe type name 			 410 */
    char pc_sn[16];		/* probe serial number			 424 */
    short test_plan_leg;	/* 					 440 */
    short test_plan_number;	/*					 442 */
    short leg;		/*					 444 */
    unsigned short ParReg[48]; /* number of pt for parsing region 446 */
    short spare ; /* to preserv 4 bytes boundary  542 */
    EcTestInfo ectest[MaxTest]; /*  size 40 * 8 = 320 bytes  start from byte 544  */
    /* SMS|Christian - 2019/05/27 02:46 PM | tms#20848 - Revert code */
    char free_space5[136]; /*                  864 */
    int data_type;		/* 0=miz18,       -1=miz18a		1000
                   1=miz30(MHI),   2=miz30(Z)
                   3=unix miz18,   4=unix miz18a
                   7=MIZ30_SIMS
                  6700 =  westinghouse 8.0 TC6700  format
                  6701 =  westinghouse 8.1 TC6700  format
                  6702 =  westinghouse 8.2 TC6700  format
                  67701 = westinghouse 8.4 TC6700- Miz70 format with MHI,X probe*/

    int entry_num;		/*					1004 */
    int data_format;	/*
                    (1<<0) PARSE DATA defined as W_PARSE					1008 */
    int data_version; /*       version number start from 84100 and increased as more info are stuffed  1012 */
    char free_space6[8]; /*             1016 */




    /* other info starts at offset 5120 */

    int sample_rate;	/* sample rate 				1024 */
    int numStd;		/* number of standards 			1028 */
    char oper_id[32];	/* operator id and level 		1032 */
    char std_sn[6][32];	/* serial number of standards 		1064 */
    char probe_des[128];	/* probe description 			1256 */
    char probe_type[64];	/* probe size and description 		1384 */
    char probe_lengths[64];	/* lengths of probe and ext. cables 	1448 */
    char cable_material[32];	/* cable description		1512 */

    char tester_sn[32];	/* serial number of tester 		1544 */
    char tester_name[32];	/* type of tester 			1576 */

    unsigned long interpolation; /* tc6700 interpolation on or off 	1608 */
        unsigned long qtyContext;       /* number of context 		1612 */

    int max_number_channels; /* set to the value of MAX_CHAN=256 	1620 */
    int tester_config_size;  /* size of test_configation in bytes
                 size = 9216 for TC6700 8.0,
                 size = 12288 for TC6700 8.1 */

    TestFreq_82 old_81_test_disp[MAX_FREQ_ANSER];	/* old miz18 freqs              1624 */
    char config_name[MaxConfigName];	/* for compatability			1688 */
    int read_check;		/*					1752 */
    int end;		/*					1756 */
    int tester_type;	/*					1760 */
    int reserved_west[71];  /* reserve space for future use         1764 */

    /* chan order starts at offset 2048 size is 1280 bytes	*/
    long chanOrder[MAX_CHAN_X]; /* order of channels displayed for 320 of size 4= 1280 at	2048 */
    char free_space8[768]; /*                  3328 */

    /* chan info starts at offset at 4096 new size 10240 	*/
    ChannelInfo chan[MAX_CHAN_X]; /* channel information of size 32 bytes for 320 chan  4096 */
    int dus_space[1536]; /*                  14336 */
//	char free_space9[4944]; /*                  14336 */

    /* tester configuration goes here */
        /* size = 1024 * 12 = 12288 for TC6700 8.1 tester */
    /* size = 1024 * 9 = 9216 for TC6700 tester */
    /* size = 1024 for miz18 tester */
    char test_configuration_data[12288]; /*		start at 1024*20 =      20480  */
   /* total size of header for data_type 8.1, 8.2 or 8.3 TC6700 tester = 23 * 1024 = 23552 bytes */

    char free_space10[8192]; /* 8K block  used for omni200 ASCII configuration    32768 */
    TestFreq test[MIZ70_MAX_FREQS];  /* new test freqs for MHI size 8 bytes for 32 freqs=512      start at  40960 */
    short union_ticks[300];  /*41216*/
    int rpc_union_left_offset; /*41816*/
    int rpc_union_right_offset; /*41820*/
    int vision_flag; /*SMS|Lucas - 2017/05/15 10:04 AM | tms#17128 */ /*41824*/
    char free_space11[156]; /*                  41828 */
        /* total size of header for data_type 8.4 = 41 * 1024 = 41984 bytes */
#ifdef __cplusplus
    sTubeHeader()
    {
        memset(this, 0, sizeof( sTubeHeader));
    }
#endif

} TubeHeader;


struct TubeData {
    TubeHeader hdr;
    int source;			/* source of the data */

    QMap<int, Channel> channels;
    int nraw;
    int npt;			/* number of points allocated */
    int raw_npt;			/* actual number of points */

} ;

#endif // DATA_H
