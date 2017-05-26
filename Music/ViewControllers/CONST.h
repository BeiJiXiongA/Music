//
//  CONST.h
//  415proj
//
//  Created by rrrr on 13-4-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#define HOST_URL @"http://192.168.88.8/app/music/kugou.com/api"

#define SINGER_GROUP_URL @"/get_singer_group.php"
#define SINGER_GROUP_TYPE 1

//得到某个分组下面的歌手
///get_singer.php?group_id=2&page=1&number=10 group_id 分组id
//page 是第几页 缺省第一页
//number 是每页人数 缺省每页20个
#define GROUP_SINGERS_URL @"/get_singer.php"
#define GROUP_SINGERS_TYPE 2

//得到某个歌星的歌曲 
///get_music.php?singer_id 歌星的id page 是第几页 number 是每页人数

#define SINGER_MUSIC_URL @"get_music.php"
#define SINGER_MUSIC_TYPE 3

#define LIST_VIEW_CONTROLLER 4
#define ADD_MUSIC_TO_LIST 5

#define LOCAL_MUSIC_LIST 6

#define NET_CLASS_LIST 7
#define SINGER_LIST 8
#define NET_MUSIC_LIST 9
#define MUSIC_FILE_LIST 10
