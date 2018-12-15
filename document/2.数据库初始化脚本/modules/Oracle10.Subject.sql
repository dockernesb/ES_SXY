-- 主体管理 菜单
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c2815875742001587595ed710053', 'ROOT_1', '主体管理', null, 'icon-users', 10);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894f858e149270158e14ed6370026', '2c90c2815875742001587595ed710053', '法人管理', 'center/socialLegalPerson/toList.action', 'fa fa-circle-o', 1000);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('40287d815a0c146b015a0c1f05a90007', '2c90c2815875742001587595ed710053', '自然人管理', 'center/socialNaturalPerson/toList.action', 'fa fa-circle-o', 1005);

-- 主体管理 权限
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f858e149270158e1506e06002f', '402894f858e149270158e14ed6370026', 'center.socialLegalPerson', '社会法人管理页面', '进入社会法人管理页面', null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f858e730350158e73515220008', '402894f858e149270158e14ed6370026', 'center.socialLegalPerson.toview', '查看企业详细信息', '查看企业详细信息', null, null, null, null);

insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('40287d815a0c146b015a0c21da980011', '40287d815a0c146b015a0c1f05a90007', 'natural.person.list.detail', '自然人管理页面', '进入自然人管理页面', null, null, null, null);

-- 主体管理 角色权限关联表
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f858e149270158e1506e06002f');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f858e149270158e1506e06002f');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f858e730350158e73515220008');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f858e730350158e73515220008');

insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '40287d815a0c146b015a0c21da980011');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '40287d815a0c146b015a0c21da980011');

------------------------------------------- 法人管理 -------------------------------------------
drop table DT_FR_FRLXFL cascade constraints;

CREATE TABLE DT_FR_FRLXFL
(
  id VARCHAR2(50) DEFAULT sys_guid() PRIMARY KEY NOT NULL,
  FRLX_CODE INT NOT NULL,
  FRLX_NAME VARCHAR2(250) NOT NULL,
  FRFL VARCHAR2(250),
  SHOW_ORDER INT
);
COMMENT ON COLUMN DT_FR_FRLXFL.FRLX_CODE IS '法人类型代码';
COMMENT ON COLUMN DT_FR_FRLXFL.FRLX_NAME IS '法人类型名称';
COMMENT ON COLUMN DT_FR_FRLXFL.FRFL IS '法人分类';
COMMENT ON COLUMN DT_FR_FRLXFL.SHOW_ORDER IS '标签显示顺序';
COMMENT ON TABLE DT_FR_FRLXFL IS '法人类型分类表';

INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1000', '内资公司', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1100', '有限责任公司', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1110', '有限责任公司(国有独资)', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1120', '有限责任公司(外商投资企业投资)', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1121', '有限责任公司(外商投资企业合资)', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1122', '有限责任公司(外商投资企业与内资合资)', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1123', '有限责任公司(外商投资企业法人独资)', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1130', '有限责任公司(自然人投资或控股)', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1140', '有限责任公司(国有控股)', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1150', '一人有限责任公司', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1151', '有限责任公司(自然人独资)', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1152', '有限责任公司（自然人投资或控股的法人独资）', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1153', '有限责任公司（非自然人投资或控股的法人独资）', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1190', '其他有限责任公司', '有限公司', '1');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1200', '股份有限公司', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1210', '股份有限公司(上市)', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1211', '股份有限公司(上市、外商投资企业投资)', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1212', '股份有限公司(上市、自然人投资或控股)', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1213', '股份有限公司(上市、国有控股)', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1219', '其他股份有限公司(上市)', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1220', '股份有限公司(非上市)', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1221', '股份有限公司(非上市、外商投资企业投资)', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1222', '股份有限公司(非上市、自然人投资或控股)', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1223', '股份有限公司(非上市、国有控股)', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('1229', '其他股份有限公司(非上市)', '股份公司', '2');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2000', '内资分公司', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2100', '有限责任公司分公司', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2110', '有限责任公司分公司(国有独资)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2120', '有限责任公司分公司(外商投资企业投资)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2121', '有限责任公司分公司(外商投资企业合资)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2122', '有限责任公司分公司(外商投资企业与内资合资)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2123', '有限责任公司分公司(外商投资企业法人独资)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2130', '有限责任公司分公司(自然人投资或控股)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2140', '有限责任公司分公司(国有控股)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2150', '一人有限责任公司分公司', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2151', '有限责任公司分公司(自然人独资)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2152', '有限责任公司分公司(自然人投资或控股的法人独资)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2153', '有限责任公司分公司（非自然人投资或控股的法人独资）', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2190', '其他有限责任公司分公司', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2200', '股份有限公司分公司', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2210', '股份有限公司分公司(上市)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2211', '股份有限公司分公司(上市、外商投资企业投资)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2212', '股份有限公司分公司(上市、自然人投资或控股)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2213', '股份有限公司分公司(上市、国有控股)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2219', '其他股份有限公司分公司(上市)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2220', '股份有限公司分公司(非上市)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2221', '股份有限公司分公司(非上市、外商投资企业投资）', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2222', '股份有限公司分公司(非上市、自然人投资或控股)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2223', '股份有限公司分公司(非上市、国有控股)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('2229', '其他股份有限公司分公司(非上市)', '分支机构', '7');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('3000', '内资企业法人', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('3100', '全民所有制', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('3200', '集体所有制', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('3300', '股份制', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('3400', '股份合作制', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('3500', '联营', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4000', '内资非法人企业、非公司私营企业', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4100', '事业单位营业', '事业单位', '8');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4110', '国有事业单位营业', '事业单位', '8');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4120', '集体事业单位营业', '事业单位', '8');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4200', '社团法人营业', '社团法人', '9');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4210', '国有社团法人营业', '社团法人', '9');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4220', '集体社团法人营业', '社团法人', '9');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4300', '内资企业法人分支机构(非法人)', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4310', '全民所有制分支机构(非法人)', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4320', '集体分支机构(非法人)', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4330', '股份制分支机构', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4340', '股份合作制分支机构', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4400', '经营单位(非法人)', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4410', '国有经营单位(非法人)', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4420', '集体经营单位(非法人)', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4500', '非公司私营企业', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4530', '合伙企业', '合伙企业', '6');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4531', '普通合伙企业', '合伙企业', '6');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4532', '特殊普通合伙企业', '合伙企业', '6');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4533', '有限合伙企业', '合伙企业', '6');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4540', '个人独资企业', '个人独资', '10');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4550', '合伙企业分支机构', '合伙企业', '6');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4551', '普通合伙企业分支机构', '合伙企业', '6');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4552', '特殊普通合伙企业分支机构', '合伙企业', '6');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4553', '有限合伙企业分支机构', '合伙企业', '6');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4560', '个人独资企业分支机构', '个人独资', '10');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4600', '联营', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('4700', '股份制企业(非法人)', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5000', '外商投资企业', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5100', '有限责任公司', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5110', '有限责任公司(中外合资)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5120', '有限责任公司(中外合作)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5130', '有限责任公司(外商合资)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5140', '有限责任公司(外国自然人独资)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5150', '有限责任公司(外国法人独资)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5160', '有限责任公司(外国非法人经济组织独资)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5190', '其他', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5200', '股份有限公司', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5210', '股份有限公司(中外合资、未上市)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5220', '股份有限公司(中外合资、上市)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5230', '股份有限公司(外商合资、未上市)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5240', '股份有限公司(外商合资、上市)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5290', '其他', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5300', '非公司', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5310', '非公司外商投资企业(中外合作)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5320', '非公司外商投资企业(外商合资)', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5390', '其他', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5400', '外商投资合伙企业', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5410', '普通合伙企业', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5420', '特殊普通合伙企业', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5430', '有限合伙企业', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5490', '其他', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5800', '外商投资企业分支机构', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5810', '分公司', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5820', '非公司外商投资企业分支机构', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5830', '办事处', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5840', '外商投资合伙企业分支机构', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('5890', '其他', '外商投资', '3');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6000', '台、港、澳投资企业', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6100', '有限责任公司', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6110', '有限责任公司(台港澳与境内合资)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6120', '有限责任公司(台港澳与境内合作)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6130', '有限责任公司(台港澳合资)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6140', '有限责任公司(台港澳自然人独资)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6150', '有限责任公司(台港澳法人独资)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6160', '有限责任公司(台港澳非法人经济组织独资)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6170', '有限责任公司(台港澳与外国投资者合资)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6190', '其他', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6200', '股份有限公司', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6210', '股份有限公司(台港澳与境内合资、未上市)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6220', '股份有限公司(台港澳与境内合资、上市)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6230', '股份有限公司(台港澳合资、未上市)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6240', '股份有限公司(台港澳合资、上市)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6250', '股份有限公司(台港澳与外国投资者合资、未上市)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6260', '股份有限公司(台港澳与外国投资者合资、上市)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6290', '其他', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6300', '非公司', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6310', '非公司台、港、澳企业(台港澳与境内合作)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6320', '非公司台、港、澳企业(台港澳合资)', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6390', '其他', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6400', '港、澳、台投资合伙企业', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6410', '普通合伙企业', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6420', '特殊普通合伙企业', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6430', '有限合伙企业', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6490', '其他', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6800', '台、港、澳投资企业分支机构', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6810', '分公司', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6820', '非公司台、港、澳投资企业分支机构', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6830', '办事处', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6840', '港、澳、台投资合伙企业分支机构', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('6890', '其他', '港澳台投资', '4');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('7000', '外国（地区）企业', '外国（地区）企业', '5');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('7100', '外国（地区）公司分支机构', '外国（地区）企业', '5');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('7110', '外国(地区)无限责任公司分支机构', '外国（地区）企业', '5');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('7120', '外国(地区)有限责任公司分支机构', '外国（地区）企业', '5');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('7130', '外国(地区)股份有限责任公司分支机构', '外国（地区）企业', '5');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('7190', '外国(地区)其他形式公司分支机构', '外国（地区）企业', '5');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('7200', '外国(地区)企业常驻代表机构', '外国（地区）企业', '5');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('7300', '外国(地区)企业在中国境内从事经营活动', '外国（地区）企业', '5');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('7310', '分公司', '外国（地区）企业', '5');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('7390', '其他', '外国（地区）企业', '5');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('8000', '集团', '集团', '11');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('9000', '其他类型', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('9100', '农民专业合作经济组织', '农专', '12');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('9200', '农民专业合作社分支机构', '农专', '12');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('9900', '其他', '其他', '99');
INSERT INTO DT_FR_FRLXFL (FRLX_CODE, FRLX_NAME, FRFL, SHOW_ORDER) VALUES ('9999', '个体', '其他', '99');

------------------------------------------- 法人管理 END-------------------------------------------


-------------------------------------------- 法人变更信息start------------------------------------------
DROP TABLE YW_L_JGBGINFO CASCADE CONSTRAINTS;
DROP TABLE YW_L_DJGBGJILU CASCADE CONSTRAINTS;
DROP TABLE YW_L_GDBGJILU CASCADE CONSTRAINTS;
DROP TABLE YW_L_JGBGJILU CASCADE CONSTRAINTS;

--变更前后记录表
create table YW_L_JGBGINFO
(
  id        VARCHAR2(50) not null,
  bg_time   DATE,
  bg_item   VARCHAR2(150),
  bg_before VARCHAR2(4000),
  bg_after  VARCHAR2(4000),
  gszch     VARCHAR2(200),
  zzjgdm    VARCHAR2(200),
  tyshxydm  VARCHAR2(200)
);

comment on table YW_L_JGBGINFO
  is '机构变更信息表';
comment on column YW_L_JGBGINFO.id
  is '主键';
comment on column YW_L_JGBGINFO.bg_time
  is '变更时间';
comment on column YW_L_JGBGINFO.bg_item
  is '变更项目';
comment on column YW_L_JGBGINFO.bg_before
  is '变更前';
comment on column YW_L_JGBGINFO.bg_after
  is '变更后';
comment on column YW_L_JGBGINFO.gszch
  is '工商注册号';
comment on column YW_L_JGBGINFO.zzjgdm
  is '组织机构代码';
comment on column YW_L_JGBGINFO.tyshxydm
  is '统一社会信用代码';
 
--董监高变更记录表
create table YW_L_DJGBGJILU
(
  id          VARCHAR2(50) not null,
  status      VARCHAR2(2) default 0 not null,
  source      VARCHAR2(2),
  create_time DATE,
  create_user VARCHAR2(50),
  bmbm        VARCHAR2(50),
  bmmc        VARCHAR2(200),
  tgrq        VARCHAR2(200),
  rwbh        VARCHAR2(50),
  zzjgdm      VARCHAR2(200),
  jgqcyw      VARCHAR2(200),
  jgqc        VARCHAR2(200),
  gszch       VARCHAR2(200),
  tyshxydm    VARCHAR2(200),
  bz          VARCHAR2(500),
  xm          VARCHAR2(100),
  zjlx        VARCHAR2(100),
  zjhm        VARCHAR2(100),
  zwlx        VARCHAR2(100),
  gj          VARCHAR2(200),
  state       VARCHAR2(2),
  bghzrq      VARCHAR2(200)
);

comment on table YW_L_DJGBGJILU
  is '董监高变更记录表';
comment on column YW_L_DJGBGJILU.id
  is '主键';
comment on column YW_L_DJGBGJILU.status
  is '数据的状态（是否可用，是否变更过等）';
comment on column YW_L_DJGBGJILU.source
  is '数据来源';
comment on column YW_L_DJGBGJILU.create_time
  is '创建时间';
comment on column YW_L_DJGBGJILU.create_user
  is '创建人ID';
comment on column YW_L_DJGBGJILU.bmbm
  is '信息提供部门编码';
comment on column YW_L_DJGBGJILU.bmmc
  is '信息提供部门名称';
comment on column YW_L_DJGBGJILU.tgrq
  is '提供日期';
comment on column YW_L_DJGBGJILU.rwbh
  is '任务编号';
comment on column YW_L_DJGBGJILU.zzjgdm
  is '组织机构代码';
comment on column YW_L_DJGBGJILU.jgqcyw
  is '机构全称英文';
comment on column YW_L_DJGBGJILU.jgqc
  is '机构全称中文';
comment on column YW_L_DJGBGJILU.gszch
  is '工商注册号（单位注册号）';
comment on column YW_L_DJGBGJILU.tyshxydm
  is '统一社会信用代码';
comment on column YW_L_DJGBGJILU.bz
  is '备注';
comment on column YW_L_DJGBGJILU.xm
  is '姓名';
comment on column YW_L_DJGBGJILU.zjlx
  is '证件类型';
comment on column YW_L_DJGBGJILU.zjhm
  is '证件号码';
comment on column YW_L_DJGBGJILU.zwlx
  is '职务类型（级别）';
comment on column YW_L_DJGBGJILU.gj
  is '国籍';
comment on column YW_L_DJGBGJILU.state
  is '数据的状态()';
comment on column YW_L_DJGBGJILU.bghzrq
  is '（变更）核准日期';

-- 股东变更记录表
create table YW_L_GDBGJILU
(
  id          VARCHAR2(50) not null,
  status      VARCHAR2(2),
  source      VARCHAR2(2),
  create_time DATE,
  create_user VARCHAR2(50),
  bmbm        VARCHAR2(50),
  bmmc        VARCHAR2(200),
  tgrq        VARCHAR2(200),
  rwbh        VARCHAR2(50),
  zzjgdm      VARCHAR2(200),
  jgqcyw      VARCHAR2(200),
  jgqc        VARCHAR2(200),
  gszch       VARCHAR2(200),
  tyshxydm    VARCHAR2(200),
  bz          VARCHAR2(500),
  gdlx        VARCHAR2(200),
  gdmc        VARCHAR2(100),
  rjcz        NUMBER,
  sjcz        NUMBER,
  djjgmc      VARCHAR2(200),
  djrq        VARCHAR2(200),
  gsgqczzm    VARCHAR2(200),
  bgrq        VARCHAR2(200),
  state       VARCHAR2(2)
);
comment on table YW_L_GDBGJILU
  is '股东变更记录表';
comment on column YW_L_GDBGJILU.id
  is '主键';
comment on column YW_L_GDBGJILU.status
  is '数据的状态（记录是否是删除状态）';
comment on column YW_L_GDBGJILU.source
  is '数据来源';
comment on column YW_L_GDBGJILU.create_time
  is '创建时间';
comment on column YW_L_GDBGJILU.create_user
  is '创建人ID';
comment on column YW_L_GDBGJILU.bmbm
  is '信息提供部门编码';
comment on column YW_L_GDBGJILU.bmmc
  is '信息提供部门名称';
comment on column YW_L_GDBGJILU.tgrq
  is '提供日期';
comment on column YW_L_GDBGJILU.rwbh
  is '任务编号';
comment on column YW_L_GDBGJILU.zzjgdm
  is '组织机构代码';
comment on column YW_L_GDBGJILU.jgqcyw
  is '机构全称英文';
comment on column YW_L_GDBGJILU.jgqc
  is '机构全称中文';
comment on column YW_L_GDBGJILU.gszch
  is '工商注册号（单位注册号）';
comment on column YW_L_GDBGJILU.tyshxydm
  is '统一社会信用代码';
comment on column YW_L_GDBGJILU.bz
  is '备注';
comment on column YW_L_GDBGJILU.gdlx
  is '股东类型';
comment on column YW_L_GDBGJILU.gdmc
  is '股东名称';
comment on column YW_L_GDBGJILU.rjcz
  is '认缴出资（万元）';
comment on column YW_L_GDBGJILU.sjcz
  is '实缴出资（万元）';
comment on column YW_L_GDBGJILU.djjgmc
  is '登记机关名称';
comment on column YW_L_GDBGJILU.djrq
  is '登记日期';
comment on column YW_L_GDBGJILU.gsgqczzm
  is '公司股权出质证明';
comment on column YW_L_GDBGJILU.bgrq
  is '变更日期';
comment on column YW_L_GDBGJILU.state
  is '数据的状态（记录是否已被程序处理,0-未处理，1-已处理）';

-- 企业基本信息变更记录表
create table YW_L_JGBGJILU
(
  id          VARCHAR2(50) not null,
  status      VARCHAR2(2) default 0 not null,
  source      VARCHAR2(2),
  create_time DATE,
  create_user VARCHAR2(50),
  bmbm        VARCHAR2(50),
  bmmc        VARCHAR2(200),
  tgrq        DATE,
  rwbh        VARCHAR2(50),
  zzjgdm      VARCHAR2(200),
  jgqcyw      VARCHAR2(200),
  jgqc        VARCHAR2(200),
  gszch       VARCHAR2(200),
  tyshxydm    VARCHAR2(200),
  fddbrxm     VARCHAR2(500),
  fddbrzjlx   VARCHAR2(500),
  fddbrzjhm   VARCHAR2(500),
  zczj        NUMBER,
  jyfw        VARCHAR2(4000),
  qylxdm      VARCHAR2(200),
  qylxmc      VARCHAR2(200),
  sshymc      VARCHAR2(200),
  sshydm      VARCHAR2(200),
  qylxdm_new  VARCHAR2(200),
  qylxmc_new  VARCHAR2(200),
  sshymc_new  VARCHAR2(200),
  sshydm_new  VARCHAR2(200),
  jgdz        VARCHAR2(500),
  fzjgmc      VARCHAR2(200),
  fzrq        VARCHAR2(200),
  hzrq        VARCHAR2(200)
);

comment on table YW_L_JGBGJILU
  is '机构变更记录表';
comment on column YW_L_JGBGJILU.id
  is '主键';
comment on column YW_L_JGBGJILU.status
  is '数据的状态（是否可用，是否变更过等）';
comment on column YW_L_JGBGJILU.source
  is '数据来源';
comment on column YW_L_JGBGJILU.create_time
  is '创建时间';
comment on column YW_L_JGBGJILU.create_user
  is '创建人ID';
comment on column YW_L_JGBGJILU.bmbm
  is '信息提供部门编码';
comment on column YW_L_JGBGJILU.bmmc
  is '信息提供部门名称';
comment on column YW_L_JGBGJILU.tgrq
  is '提供日期';
comment on column YW_L_JGBGJILU.rwbh
  is '任务编号';
comment on column YW_L_JGBGJILU.zzjgdm
  is '组织机构代码';
comment on column YW_L_JGBGJILU.jgqcyw
  is '机构全称英文';
comment on column YW_L_JGBGJILU.jgqc
  is '机构全称中文';
comment on column YW_L_JGBGJILU.gszch
  is '工商注册号（单位注册号）';
comment on column YW_L_JGBGJILU.tyshxydm
  is '统一社会信用代码';
comment on column YW_L_JGBGJILU.fddbrxm
  is '法定代表人姓名';
comment on column YW_L_JGBGJILU.fddbrzjlx
  is '法定代表人证件名称（身份证、驾驶证等）';
comment on column YW_L_JGBGJILU.fddbrzjhm
  is '法定代表人证件号码（身份证、驾驶证等）';
comment on column YW_L_JGBGJILU.zczj
  is '注册（开办）资金（万元）';
comment on column YW_L_JGBGJILU.jyfw
  is '经营范围';
comment on column YW_L_JGBGJILU.qylxdm
  is '企业类型代码';
comment on column YW_L_JGBGJILU.qylxmc
  is '企业类型名称';
comment on column YW_L_JGBGJILU.sshymc
  is '所属行业名称';
comment on column YW_L_JGBGJILU.sshydm
  is '所属行业代码';
comment on column YW_L_JGBGJILU.jgdz
  is '机构地址（住所）';
comment on column YW_L_JGBGJILU.fzjgmc
  is '发证机关名称';
comment on column YW_L_JGBGJILU.fzrq
  is '发证日期';
comment on column YW_L_JGBGJILU.hzrq
  is '（变更）核准日期';
-------------------------------------------- 法人变更信息end------------------------------------------

commit;
