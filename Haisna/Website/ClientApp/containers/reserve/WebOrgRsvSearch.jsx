import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import qs from 'qs';

import moment from 'moment';

import PageLayout from '../../layouts/PageLayout';
import MessageBanner from '../../components/MessageBanner';
import WebOrgRsvSearchHeaderForm from './WebOrgRsvSearchHeaderForm';
import WebOrgRsvSearchBody from './WebOrgRsvSearchBody';
import Pagination from '../../components/Pagination';

import WebOrgRsvMain from '../../containers/reserve/WebOrgRsvMain';
import { openWebOrgRsvMainGuide } from '../../modules/reserve/webOrgRsvModule';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const SearchedKeyword = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const ColorCircle = styled.span`
  color: #cc9999;
`;

const WebOrgRsvSearch = ({ conditions, history, match, totalCount, data, message, onWebOrgRsvMainGuide }) => (
  <PageLayout title="web団体予約情報検索">
    <MessageBanner messages={message} />
    <WebOrgRsvSearchHeaderForm {...this.props} />
    {totalCount !== null && totalCount > 0 &&
      <div>
        <div style={{ paddingTop: 10, paddingBottom: 10 }}>
          {<span>「<SearchedKeyword>{moment(conditions.stropdate).format('YYYY年M月D日')}～{moment(conditions.endcsldate).format('YYYY年M月D日')}</SearchedKeyword>」のweb予約者一覧を表示しています。</span>}
          <div style={{ marginLeft: 8 }}><TotalCount>{totalCount}</TotalCount>件の予約情報があります。</div>
          <div style={{ marginTop: 10 }}><ColorCircle>●</ColorCircle>氏名を選択すると、該当するweb予約情報の登録画面が表示されます。</div>
          <div><ColorCircle>●</ColorCircle>すでに編集済みの予約情報については、「受診情報へ」を選択すると受診情報詳細画面が表示されます。</div>
        </div>
        <WebOrgRsvSearchBody data={data} openWebOrgRsvMainGuide={onWebOrgRsvMainGuide} conditions={conditions} />
        {totalCount > conditions.limit && (
          <Pagination
            startPos={((conditions.page - 1) * conditions.limit) + 1}
            rowsPerPage={parseInt(conditions.limit, 10)}
            totalCount={totalCount}
            onSelect={(page) => {
              // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
              // 結果的にcomponentWillReceivePropsメソッドが呼ばれることにより画面の再描画が行われる
              history.push({
                pathname: match.url,
                search: qs.stringify({ ...conditions, page }),
              });
            }}
          />
        )}
        <WebOrgRsvMain />
      </div>
    }
  </PageLayout>
);

// propTypesの定義
WebOrgRsvSearch.propTypes = {
  conditions: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  match: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  data: PropTypes.arrayOf(PropTypes.shape()),
  onWebOrgRsvMainGuide: PropTypes.func.isRequired,
};

// defaultPropsの定義
WebOrgRsvSearch.defaultProps = {
  data: [],
  totalCount: null,
};

const mapStateToProps = (state) => (
  {
    message: state.app.reserve.webOrgRsv.webOrgRsvSearch.message,
    conditions: state.app.reserve.webOrgRsv.webOrgRsvSearch.conditions,
    totalCount: state.app.reserve.webOrgRsv.webOrgRsvSearch.totalCount,
    data: state.app.reserve.webOrgRsv.webOrgRsvSearch.data,
  }
);

const mapDispatchToProps = (dispatch) => ({
  onWebOrgRsvMainGuide: (conditions) => {
    const { data } = conditions;
    const params = {};
    params.csldate = data.csldate;
    params.webno = data.webno;
    params.strcsldate = conditions.strcsldate;
    params.endcsldate = conditions.endcsldate;
    params.key = conditions.key;
    params.stropdate = conditions.stropdate;
    params.endopdate = conditions.endopdate;
    params.orgcd1 = '';
    params.orgcd2 = '';
    params.opmode = conditions.opmode;
    params.regflg = data.regflg;
    params.order = conditions.order;
    params.mousi = '';

    dispatch(openWebOrgRsvMainGuide({ params }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(WebOrgRsvSearch);
