import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';

import GuideBase from '../../components/common/GuideBase';
import GdePerBillListBody from './GdePerBillListBody';
import GdePerBillListHeaderFrom from './GdePerBillListHeaderFrom';

import { closeGdePerBillGuide, selectGdePerBill } from '../../modules/bill/perBillModule';

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const SearchedKeyword = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const Wrapper = styled.div`
  height: 600px;
  width: 1150px;
  margin-top: 10px;
  overflow-y: auto;
`;

const GdePerBillList = (props) => {
  const { onSelectGdePerBill, listPerBill, startDmdDate, endDmdDate, index } = props;
  return (
    <GuideBase {...props} title="個人請求書の検索" usePagination={false} >
      <Wrapper>
        <div>
          <GdePerBillListHeaderFrom />
          <div>
            <span>「<SearchedKeyword>{startDmdDate && moment(startDmdDate).format('YYYY年M月DD日')}～{endDmdDate && moment(endDmdDate).format('YYYY年M月DD日')}</SearchedKeyword>」の</span>請求書一覧を表示しています。<br />
            <p>対象請求書は<TotalCount>{listPerBill && listPerBill.length}</TotalCount>枚です。</p>
            <GdePerBillListBody data={listPerBill} onSelectGdePerBill={onSelectGdePerBill} index={index} />
          </div>
        </div>
      </Wrapper>
    </GuideBase>
  );
};

// propTypesの定義
GdePerBillList.propTypes = {
  visible: PropTypes.bool.isRequired,
  conditions: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  onSearch: PropTypes.func,
  onClose: PropTypes.func.isRequired,
  onSelectGdePerBill: PropTypes.func.isRequired,
  closeGdePerBillGuide: PropTypes.func,
  listPerBill: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  startDmdDate: PropTypes.string.isRequired,
  endDmdDate: PropTypes.string.isRequired,
  index: PropTypes.number,
};
// defaultPropsの定義
GdePerBillList.defaultProps = {
  totalCount: undefined,
  onSearch: undefined,
  closeGdePerBillGuide: undefined,
  index: null,
};
const mapStateToProps = (state) => ({
  // 検索条件
  conditions: state.app.bill.perBill.gdePerBillGuide.conditions,
  visible: state.app.bill.perBill.gdePerBillGuide.visible,
  listPerBill: state.app.bill.perBill.gdePerBillGuide.listPerBill,
  startDmdDate: state.app.bill.perBill.gdePerBillGuide.startDmdDate,
  endDmdDate: state.app.bill.perBill.gdePerBillGuide.endDmdDate,
  index: state.app.bill.perBill.gdePerBillGuide.index,

});

const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeGdePerBillGuide());
  },

  onSelectGdePerBill: (gdePerBillList, index) => {
    dispatch(selectGdePerBill({ gdePerBillList, index }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(GdePerBillList));
