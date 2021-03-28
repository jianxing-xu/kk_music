/// NewH5App 接口
/// 首页大接口 http://m.kuwo.cn/newh5app/api/mobile/v1/home
/// bannerList.digest
/// 8: 歌单
/// 13：专辑
///

// 排行榜 http://m.kuwo.cn/newh5app/api/mobile/v1/typelist/rank
// 榜单详情 http://m.kuwo.cn/newh5app/api/mobile/v1/music/rank/16?pn=1&rn=20

// 搜索建议 http://m.kuwo.cn/newh5app/api/mobile/v1/search/tip?key=zhouff
// 搜索 http://m.kuwo.cn/newh5app/api/mobile/v1/search/all?key=毛不易

// 歌单分类词 http://m.kuwo.cn/newh5app/api/mobile/v1/typelist/playlist
// 根据分类词id拿歌单列表 http://m.kuwo.cn/newh5app/api/mobile/v1/playlist/type/173?rn=20&pn=1
// 推荐歌单new http://m.kuwo.cn/newh5app/api/mobile/v1/playlist/rcm/new
// 推荐歌单hot http://m.kuwo.cn/newh5app/api/mobile/v1/playlist/rcm/hot
// 歌单详情 http://m.kuwo.cn/newh5app/api/mobile/v1/music/playlist/3166398799?pn=2&rn=20&ua=&ip=

// 歌曲SRC http://m.kuwo.cn/newh5app/api/mobile/v1/music/src/78594604
// 歌曲信息 http://m.kuwo.cn/newh5app/api/mobile/v1/music/info/78594604

// 专辑详情 http://m.kuwo.cn/newh5app/api/mobile/v1/music/album/${专辑id}?rn=20&pn=2
// 歌手详情 http://m.kuwo.cn/newh5app/api/mobile/v1/artist/info/${歌手id}
// 更多歌手歌曲 http://m.kuwo.cn/newh5app/api/mobile/v1/music/artist/104764?pn=2&rn=10

// 视频详情 http://m.kuwo.cn/newh5app/api/mobile/v1/video/info/${歌曲id}?source=7&ip=
// 视频-相关推荐 http://m.kuwo.cn/newh5app/api/mobile/v1/video/rcmlist/162291467?source=7&ip=

/// PC 接口
/// 歌曲评论：http://www.kuwo.cn/comment?type=get_comment&f=web&page=1&rows=20&digest=15&sid=${歌曲}id&uid=0&prod=newWeb&httpsStatus=1
/// 首播视频MV(需要kw_token): http://www.kuwo.cn/api/www/music/mvList?pid=236682871&pn=1&rn=30&httpsStatus=1
/// MV评论：http://www.kuwo.cn/comment?type=get_rec_comment&f=web&page=1&rows=20&digest=7&sid=155515226&uid=0&prod=newWeb&httpsStatus=1
/// 歌手列表(kw_token):http://www.kuwo.cn/api/www/artist/artistInfo?category=0&pn=1&rn=100&httpsStatus=1&reqId=e4000fb0-871e-11eb-b95c-25a17492335b
