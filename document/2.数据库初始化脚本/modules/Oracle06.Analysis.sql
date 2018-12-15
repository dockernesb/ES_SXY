
/*******************************   运行分析模块BEGIN    ***************************************************************/

--菜单
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894b65a160b9f015a1620e9bf000f', '2c90c281588489c001588588c7df006c', '运行分析', null, 'icon-power', 65);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894b65a160b9f015a1621e3f00017', '402894b65a160b9f015a1620e9bf000f', '业务应用分析', '/center/businessApplication//toBusinessApplication.action', 'fa fa-circle-o', 66);

--权限
insert into SYS_PRIVILEGE (sys_privilege_id,sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894b65a160b9f015a16235fee0023','402894b65a160b9f015a1621e3f00017', 'businessApplication.query', '业务应用分析', null, null, null, null, null);

--角色权限分配
--1、业务应用分析
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894b65a160b9f015a16235fee0023');

--用户权限分配
--1、业务应用分析
insert into SYS_USER_TO_PRIVILEGE (sys_user_id, sys_privilege_id)
values ('8aa0bef8446c32a301446c409a950002', '402894b65a160b9f015a16235fee0023');
/*******************************   运行分析模块 END   *********************************************************************/

/*******************************   多维分析模块BEGIN    *********************************************************************/

--菜单
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894a95944db92015944dccfb0000c', '2c90c281588489c001588588c7df006c', '多维分析', null, 'icon-paper-plane', 60);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894a95944db92015944de8b490019', '402894a95944db92015944dccfb0000c', '发展趋势分析', '/center/developmentTrend/toDevelopmentTrend.action', 'fa fa-circle-o', 64);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894a95944db92015944df42ac001e', '402894a95944db92015944dccfb0000c', '区域信用分析', '/center/regionalCredit/toRegionalCredit.action', 'fa fa-circle-o', 62);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894a95944db92015944dfe8420027', '402894a95944db92015944dccfb0000c', '行业信用分析', '/center/industryCredit/toIndustryCredit.action', 'fa fa-circle-o', 61);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894a95944db92015944e087b2002c', '402894a95944db92015944dccfb0000c', '企业年龄分析', '/center/timeCredit/toTimeCredit.action', 'fa fa-circle-o', 63);

--权限
insert into SYS_PRIVILEGE (sys_privilege_id,sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894a95944db92015944e23abf003b','402894a95944db92015944de8b490019', 'developmentTrend.query', '发展趋势分析查询', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id,sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count,display_order)
values ('402894a95944db92015944e2d46a0041', '402894a95944db92015944df42ac001e', 'regionalCredit.query', '区域信用分析查询', null, null, null, null,null);
insert into SYS_PRIVILEGE (sys_privilege_id,sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count,display_order)
values ('402894a95944db92015944e34e6d0046','402894a95944db92015944e087b2002c', 'timeCredit.query', '区间信用分析查询', null, null, null, null,null);
insert into SYS_PRIVILEGE (sys_privilege_id,sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count,display_order)
values ('402894a95944db92015944e3b9a8004b','402894a95944db92015944dfe8420027', 'industryCredit.query', '行业区域分析查询', null, null, null, null,null);


--角色权限配置
--1、发展趋势分析查询
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894a95944db92015944e23abf003b');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894a95944db92015944e23abf003b');
--2、区域信用分析查询
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894a95944db92015944e2d46a0041');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894a95944db92015944e2d46a0041');
--3、区间信用分析查询
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894a95944db92015944e34e6d0046');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894a95944db92015944e34e6d0046');
--4、行业区域分析查询
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894a95944db92015944e3b9a8004b');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894a95944db92015944e3b9a8004b');

--用户权限配置
--1、发展趋势分析查询
insert into SYS_USER_TO_PRIVILEGE (sys_user_id, sys_privilege_id)
values ('8aa0bef8446c32a301446c409a950002', '402894a95944db92015944e23abf003b');
--2、区域信用分析查询
insert into SYS_USER_TO_PRIVILEGE (sys_user_id, sys_privilege_id)
values ('8aa0bef8446c32a301446c409a950002', '402894a95944db92015944e2d46a0041');
--3、区间信用分析查询
insert into SYS_USER_TO_PRIVILEGE (sys_user_id, sys_privilege_id)
values ('8aa0bef8446c32a301446c409a950002', '402894a95944db92015944e34e6d0046');
--4、行业区域分析查询
insert into SYS_USER_TO_PRIVILEGE (sys_user_id, sys_privilege_id)
values ('8aa0bef8446c32a301446c409a950002', '402894a95944db92015944e3b9a8004b');
/*******************************   多维分析模块END    *********************************************************************/

--字典
--1.行政区划
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894a959480bd50159484d8f2d0079', 'administrativeArea', '行政区划代码表', '行政区划代码对应表，用于统计分析中多维分析的行政区划查询');
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bc59b54ec40159b55740fd000b', '402894a959480bd50159484d8f2d0079', '320582', '张家港市', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bc59b54ec40159b55740fd000c', '402894a959480bd50159484d8f2d0079', '320506', '吴中区', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bc59b54ec40159b55740fd000d', '402894a959480bd50159484d8f2d0079', '320505', '虎丘区', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bc59b54ec40159b55740fd000e', '402894a959480bd50159484d8f2d0079', '320585', '太仓市', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bc59b54ec40159b55740fd000f', '402894a959480bd50159484d8f2d0079', '320581', '常熟市', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bc59b54ec40159b55740fd0010', '402894a959480bd50159484d8f2d0079', '320583', '昆山市', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bc59b54ec40159b55740fd0011', '402894a959480bd50159484d8f2d0079', '320509', '吴江区', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bc59b54ec40159b55740fd0012', '402894a959480bd50159484d8f2d0079', '320507', '相城区', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bc59b54ec40159b55740fd0013', '402894a959480bd50159484d8f2d0079', '320508', '姑苏区', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bc59b54ec40159b55740fd0014', '402894a959480bd50159484d8f2d0079', '320501', '市辖区', null);
--2.企业年龄
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894d8597758cd015977d423620012', 'enterpriseAge', '企业年龄字典表', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894ba5a3b5b78015a3bb791610033', '402894d8597758cd015977d423620012', 'NLF', '30年以上', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894ba5a3b5b78015a3bb791620034', '402894d8597758cd015977d423620012', 'NLC', '5至10年', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894ba5a3b5b78015a3bb791620035', '402894d8597758cd015977d423620012', 'NLB', '3至5年', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894ba5a3b5b78015a3bb791620036', '402894d8597758cd015977d423620012', 'NLD', '10至20年', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894ba5a3b5b78015a3bb791620037', '402894d8597758cd015977d423620012', 'NLA', '不足3年', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894ba5a3b5b78015a3bb791620038', '402894d8597758cd015977d423620012', 'NLE', '20至30年', null);

--3.统计分析
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894bb5a267b69015a26e72c7a0025', 'appeal_content', '异议申诉内容类型', '用于统计分析-业务应用分析-异议申诉内容类型统计');
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894bb5a267b69015a26e903160037', 'repair_content', '信用修复内容类型', '用于统计分析-业务应用分析-修复内容类型统计');
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894bb5a257da3015a258a22b30005', 'reviewCategory', '信用核查审查类别', '用于统计应用分析-业务应用分析-信用核查审查类别分析');

insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26dc80ff001d', '402894bb5a257da3015a258a22b30005', '1', '失信信息', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26dc80ff001e', '402894bb5a257da3015a258a22b30005', '4', '参保信息', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26dc80ff001f', '402894bb5a257da3015a258a22b30005', '0', '许可资质信息', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26dc80ff0020', '402894bb5a257da3015a258a22b30005', '3', '表彰荣誉', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26dc80ff0021', '402894bb5a257da3015a258a22b30005', '5', '其他信息', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26dc80ff0022', '402894bb5a257da3015a258a22b30005', '2', '履行约定', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26e783ef002f', '402894bb5a267b69015a26e72c7a0025', '0', '企业概况', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26e783ef0030', '402894bb5a267b69015a26e72c7a0025', '4', '表彰荣誉', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26e783ef0031', '402894bb5a267b69015a26e72c7a0025', '3', '履行约定信息', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26e783ef0032', '402894bb5a267b69015a26e72c7a0025', '1', '许可资质', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26e783ef0033', '402894bb5a267b69015a26e72c7a0025', '2', '失信信息', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26e783ef0034', '402894bb5a267b69015a26e72c7a0025', '5', '参保信息', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26e9031c0038', '402894bb5a267b69015a26e903160037', '2', '参保信息', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26e9031c0039', '402894bb5a267b69015a26e903160037', '0', '失信信息', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894bb5a267b69015a26e9031c003a', '402894bb5a267b69015a26e903160037', '1', '履行约定信息', null);
commit;