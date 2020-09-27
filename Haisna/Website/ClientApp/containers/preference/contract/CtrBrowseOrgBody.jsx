import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import Table from '../../../components/Table';
import * as Constants from '../../../constants/common';

// 検索キーを空白で分割
const SplitKey = (keyword) => {
  let keys = [];
  if (keyword && keyword.length > 0) {
    const replaceKey = keyword.replace('　', ' ');
    keys = replaceKey.trim().split(' ');
    let index = 0;
    while (index > -1) {
      index = keys.findIndex((value) => (value === ''));
      if (index > -1) {
        keys.splice(index, 1);
      }
    }
  }
  return keys;
};

// 検索キー(OrgCd)に合致する部分に<B>タグを付加
const StrongOrgCdHtml = ({ data, keyword }) => {
  let dispOrgCd1 = data.orgcd1;
  let dispOrgCd2 = data.orgcd2;
  // 検索キーを空白で分割する
  const keys = SplitKey(keyword);

  // 検索キーに合致する部分に<B>タグを付加
  if (keys && keys.length > 0) {
    for (let i = 0; i < keys.length; i += 1) {
      if (dispOrgCd1.indexOf(keys[i]) === 0) {
        const pos = dispOrgCd1.indexOf(keys[i]) + keys[i].length;
        dispOrgCd1 = <span><strong>{keys[i]}</strong>{dispOrgCd1.substring(pos)}</span>;
        break;
      }
    }
    for (let i = 0; i < keys.length; i += 1) {
      if (dispOrgCd2.indexOf(keys[i]) === 0) {
        const pos = dispOrgCd2.indexOf(keys[i]) + keys[i].length;
        dispOrgCd2 = <span><strong>{keys[i]}</strong>{dispOrgCd2.substring(pos)}</span>;
        break;
      }
    }
  }
  const dispOrgCd = <div>{dispOrgCd1}-{dispOrgCd2}</div>;
  return dispOrgCd;
};

// 配列のソート
const Compare = (propertyName) => (
  (rec1, rec2) => {
    const val1 = rec1[propertyName];
    const val2 = rec2[propertyName];
    return val1 - val2;
  }
);

// 検索キー(OrgName,OrgKName)に合致する部分に<B>タグを付加
const StrongNameHtml = ({ data, keyword }) => {
  // 検索キーを空白で分割する
  const keys = SplitKey(keyword);
  const dispName = [];
  const workPosKey = [];
  let concatName = data;
  let splitName = [];

  // 検索キーに合致する部分に<B>タグを付加
  if (data && keys && keys.length > 0) {
    keys.forEach((key) => {
      let workSubName = data;
      let pos = 0;
      while (workSubName.includes(key)) {
        pos = data.indexOf(key, pos);
        workPosKey.push({ pos, key });
        pos += key.length;
        workSubName = data.substring(pos);
      }
      concatName = concatName.split(key).join('<strong>');
    });

    workPosKey.sort(Compare('pos'));
    splitName = concatName.split('<strong>');
    if (splitName.length > 1) {
      splitName.forEach((element, index) => {
        if (index === splitName.length - 1) {
          dispName.push(<span key={`${data}-${element}`}>{element}</span>);
        } else {
          dispName.push(<span key={`${data}-${element}`}>{element}<strong>{workPosKey[index].key}</strong></span>);
        }
      });
    } else {
      dispName.push(<span key={data}>{data}</span>);
    }
  } else {
    dispName.push(<span key={data}>{data}</span>);
  }

  return dispName;
};

// 団体情報の編集 アンカーの要否
const AnchorHmtl = ({ data, keyword, params }) => {
  const { orgcd1, orgcd2, opmode, cscd } = params;
  // アンカーの要否
  let isAnchor = true;

  // 参照モードの場合、検索した団体が契約団体自身であればアンカーを張らない
  if (opmode === Constants.OPMODE_BROWSE) {
    if (data.orgcd1 === orgcd1 && data.orgcd2 === orgcd2) {
      isAnchor = false;
    }
  }
  // 個人・Webの場合
  if ((orgcd1 === Constants.ORGCD1_PERSON && orgcd2 === Constants.ORGCD2_PERSON) || (orgcd1 === Constants.ORGCD1_WEB && orgcd2 === Constants.ORGCD2_WEB)) {
    // 個人・Web以外の場合はアンカーを張らない
    if (!((data.orgcd1 === Constants.ORGCD1_PERSON && data.orgcd2 === Constants.ORGCD2_PERSON)
            || (data.orgcd1 === Constants.ORGCD1_WEB && data.orgcd2 === Constants.ORGCD2_WEB))) {
      isAnchor = false;
    }
  } else if ((data.orgcd1 === Constants.ORGCD1_PERSON && data.orgcd2 === Constants.ORGCD2_PERSON) || (data.orgcd1 === Constants.ORGCD1_WEB && data.orgcd2 === Constants.ORGCD2_WEB)) {
    isAnchor = false;
  }

  let anchor;
  if (isAnchor) {
    let linkto = `/contents/preference/contract/${opmode}/${orgcd1}/${orgcd2}/${cscd}/${data.orgcd1}/${data.orgcd2}/`;
    // 処理モードが複写の場合は更に契約期間をlinkto文字列として編集する
    if (opmode === Constants.OPMODE_COPY) {
      linkto += `${params.strdate}/${params.enddate}/refcontracts`;
    } else {
      linkto += 'refcontracts';
    }
    anchor = <Link key={data.orgname} to={linkto}><StrongNameHtml data={data.orgname} keyword={keyword} /></Link>;
  } else if (data !== null) {
    anchor = <StrongNameHtml data={data.orgname} keyword={keyword} />;
  }
  return anchor;
};

const CtrBrowseOrgBody = ({ keyword, data, match }) => (
  <Table striped hover>
    <thead>
      <tr>
        <th>団体コード</th>
        <th>団体名称</th>
        <th>団体カナ名称</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.orgcd1}-${rec.orgcd2}`}>
          <td><StrongOrgCdHtml data={rec} keyword={keyword} /></td>
          <td><AnchorHmtl data={rec} keyword={keyword} params={match.params} /></td>
          <td><StrongNameHtml data={rec.orgkname} keyword={keyword} /></td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
CtrBrowseOrgBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  keyword: PropTypes.string,
  match: PropTypes.shape().isRequired,
};

CtrBrowseOrgBody.defaultProps = {
  keyword: '',
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.preference.organization.organizationList.data,
  keyword: state.app.preference.organization.organizationList.conditions.keyword,
});

export default connect(mapStateToProps)(CtrBrowseOrgBody);
