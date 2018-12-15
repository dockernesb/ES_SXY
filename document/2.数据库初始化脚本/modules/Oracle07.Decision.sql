--信用地图图谱菜单
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894d858dd59880158dd60ed090032', 'ROOT_1', '信用地图', null, 'icon-credit-card', 40);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894d858dd59880158dd6264f80041', '402894d858dd59880158dd60ed090032', '信用要素分布', 'center/creditMap/toCreditElements.action', 'fa fa-circle-o', 1);
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER) 
values ('402894b65b8f1c7f015b8f49ba950061', '402894d858dd59880158dd60ed090032', '高管来源分析', 'center/executivesSource/toExecutivesSource.action', 'fa fa-circle-o', 2);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894d858dd59880158dd62cd87004b', 'ROOT_1', '信用立方', null, 'icon-moustache', 45);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894d858dd59880158dd63af2e0057', '402894d858dd59880158dd62cd87004b', '信用图谱', 'center/creditCubic/toCreditAtlas.action', 'fa fa-circle-o', 1);

--增加权限
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894d858dd59880158dd649bc0005f', '402894d858dd59880158dd6264f80041', 'map.query', '信用地图查询', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894d858dd59880158dd653c460064', '402894d858dd59880158dd63af2e0057', 'cubic.query', '信用立方查询', null, null, null, null, null);
insert into sys_privilege (SYS_PRIVILEGE_ID, sys_menu_id, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER) 
values ('402894b65b8f1c7f015b8f4dd87a007f', '402894b65b8f1c7f015b8f49ba950061', 'executivesSource.query', '高管来源分析查询', null, null, null, null, null);

--用户、角色分配权限
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894d858dd59880158dd649bc0005f');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894d858dd59880158dd649bc0005f');

insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894d858dd59880158dd653c460064');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894d858dd59880158dd653c460064');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) 
values ('2c90c28158761b550158762482b50015', '402894b65b8f1c7f015b8f4dd87a007f');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) 
values ('8aa0bef544713ca60144713d364a0000', '402894b65b8f1c7f015b8f4dd87a007f');

--信用地图各种信用要素查询条件字典
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894c25b9db20d015b9de052c90038', 'canbaoType', '信用地图-参保类别', '用于信用地图-信用要素分析-参保欠缴信息查询');
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894c25b9db20d015b9df089e80045', 'qianshuiType', '信用地图-欠税税种', '用于信用地图-信用要素分析-欠税信息查询');
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894b55b8f72cb015b8fc71d400009', 'qianjiaoType', '信用地图-欠缴类型', '用于信用地图-信用要素分析-欠费信息查询');

insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9ddcda210031', '402894b55b8f72cb015b8fc71d400009', 'dianfei', '电费', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9ddcda210032', '402894b55b8f72cb015b8fc71d400009', 'shuifei', '水费', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9ddcda210033', '402894b55b8f72cb015b8fc71d400009', 'ranqifei', '燃气费', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9ddcda210034', '402894b55b8f72cb015b8fc71d400009', 'huafei', '话费', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9de052c90039', '402894c25b9db20d015b9de052c90038', 'jgsydw', '机关事业单位养老保险', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9de052c9003a', '402894c25b9db20d015b9de052c90038', 'gsbx', '工伤保险', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9de052c9003b', '402894c25b9db20d015b9de052c90038', 'bcyl', '补充医疗保险', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9de052c9003c', '402894c25b9db20d015b9de052c90038', 'shengyu', '生育保险', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9de052c9003d', '402894c25b9db20d015b9de052c90038', 'czzg', '城镇职工基本医疗保险', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9de052c9003e', '402894c25b9db20d015b9de052c90038', 'deyl', '大额医疗费用补助', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9de052ca003f', '402894c25b9db20d015b9de052c90038', 'czqy', '城镇企业职工基本养老保险', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9de052ca0040', '402894c25b9db20d015b9de052c90038', 'shiye', '失业保险', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e80046', '402894c25b9db20d015b9df089e80045', 'tdzzs', '土地增值税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e80047', '402894c25b9db20d015b9df089e80045', 'fcs', '房产税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e80048', '402894c25b9db20d015b9df089e80045', 'gdzys', '耕地占用税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e80049', '402894c25b9db20d015b9df089e80045', 'grsds', '个人所得税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e8004a', '402894c25b9db20d015b9df089e80045', 'zzs', '增值税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e9004b', '402894c25b9db20d015b9df089e80045', 'yhs', '印花税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e9004c', '402894c25b9db20d015b9df089e80045', 'qs', '契税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e9004d', '402894c25b9db20d015b9df089e80045', 'qysds', '企业所得税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e9004e', '402894c25b9db20d015b9df089e80045', 'yys', '营业税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e9004f', '402894c25b9db20d015b9df089e80045', 'ccs', '车船税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e90050', '402894c25b9db20d015b9df089e80045', 'cswhjss', '城市维护建设税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e90051', '402894c25b9db20d015b9df089e80045', 'cztdsys', '城镇土地使用税', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9db20d015b9df089e90052', '402894c25b9db20d015b9df089e80045', 'ccsys', '车船使用税', null);


--高管来源分析区域查询条件字典
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894c25b9e7b94015b9ecff3300018', 'idCardRegion', '高管来源-身份证区域', '用于高管来源分析区域查询');

insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3310019', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_61', '陕西', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff331001a', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_53', '云南', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff332001b', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_15', '内蒙古', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3330027', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_51', '四川', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff332001c', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_63', '青海', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff332001d', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_62', '甘肃', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3330028', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_34', '安徽', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff332001e', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_12', '天津', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff332001f', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_11', '北京', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3320020', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_23', '黑龙江', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3320021', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_43', '湖南', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3330022', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_50', '重庆', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3330023', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_44', '广东', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3330024', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_37', '山东', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3330025', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_41', '河南', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3330026', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_31', '上海', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3330029', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_33', '浙江', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff333002a', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_54', '西藏', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff333002b', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_13', '河北', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff334002c', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_65', '新疆', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff334002d', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_36', '江西', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff334002e', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_45', '广西', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff334002f', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_14', '山西', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3340030', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_42', '湖北', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3340031', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_64', '宁夏', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3340032', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_52', '贵州', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3340033', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_32', '江苏', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3340034', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_22', '吉林', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3350035', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_21', '辽宁', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3350036', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_35', '福建', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894c25b9e7b94015b9ecff3350037', '402894c25b9e7b94015b9ecff3300018', 'gaoguan_46', '海南', null);

commit;
