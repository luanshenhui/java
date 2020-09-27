import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { reduxForm } from 'redux-form';
import qs from 'qs';

import ListHeaderFormBase from '../../components/common/ListHeaderFormBase';
import Pagination from '../../components/Pagination';
import MessageBanner from '../../components/MessageBanner';

import DailyListEditCountTitle from './DailyListEditCountTitle';
import DailyListEditEntryCondition from './DailyListEditEntryCondition';
import DailyListEditCondition from './DailyListEditCondition';
import DailyListBody from './DailyListBody';

import { openOrgGuide } from '../../modules/preference/organizationModule';
import { setDailyListParams, getDailyListRequest, openRptAllEntryGuide } from '../../modules/reserve/consultModule';
import { settingDate } from '../../modules/preference/scheduleModule';

// 表示行数一覧選択肢
const DailyListHeader = (props) => {
  const { params, message, totalcount, history } = props;

  return (
    <ListHeaderFormBase {...props} >
      <div style={{ ...(params.print === 1) && { fontSize: '9px' } }}>
        <div style={{ width: '1000px' }}>

          {/* 検索条件・件数情報の編集  */}
          <DailyListEditCountTitle {...props} />
          {/* 条件入力エレメントの編集 */}
          <DailyListEditEntryCondition {...props} />

          {/* 条件値の編集 */}
          <DailyListEditCondition {...params} />

        </div>

        <MessageBanner messages={message} />

        {(!message || message.length === 0) && <DailyListBody {...props} />}
        {params.getCount !== '*'
          && params.getCount !== ''
          && totalcount > parseInt(params.getCount, 10)
          && (
            <Pagination
              startPos={((params.startPos - 1) * parseInt(params.getCount, 10)) + 1}
              rowsPerPage={parseInt(params.getCount, 10)}
              totalCount={totalcount}
              onSelect={(page) => {
                // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
                // 結果的にcomponentWillReceivePropsメソッドが呼ばれることにより画面の再描画が行われる
                history.push({
                  pathname: '/reserve/frontdoor/dailylist',
                  search: qs.stringify({ ...params, page, isSearchButtonClick: '0' }),
                });
              }}
            />
          )}
      </div>
    </ListHeaderFormBase>
  );
};

// プロパティの型を定義する
DailyListHeader.propTypes = {
  totalcount: PropTypes.number.isRequired,
  params: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  setNewParams: PropTypes.func.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onOpenRptAllEntryGuide: PropTypes.func.isRequired,
};

// defaultPropsの定義
const mapStateToProps = (state) => ({
  params: state.app.reserve.consult.dailyList.params,
  initialValues: state.app.reserve.consult.dailyList.params,
  message: state.app.reserve.consult.dailyList.message,
  data: state.app.reserve.consult.dailyList.data,
  totalcount: state.app.reserve.consult.dailyList.totalcount,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    dispatch(setDailyListParams({ newParams: { isSearching: true } }));
    const { isSearchButtonClick = '1' } = conditions;
    if (isSearchButtonClick === '1') {
      dispatch(getDailyListRequest({
        ...conditions,
        sortKey: 0,
        sortType: 0,
        startPos: conditions.page,
      }));
    } else {
      dispatch(getDailyListRequest({
        ...conditions,
        startPos: conditions.page,
      }));
    }
  },
  initializeList: () => {
  },
  setNewParams: (params) => {
    dispatch(setDailyListParams({ newParams: params }));
  },
  onOpenOrgGuide: (action) => {
    // 開くアクションを呼び出す
    dispatch(openOrgGuide(action));
  },
  onOpenMntCapacityList: (startDate) => {
    // 開くアクションを呼び出す
    dispatch(settingDate({ startDate, isRetrieval: true }));
  },
  onOpenRptAllEntryGuide: (params) => {
    // 当日ｉｄ発番
    // 開くアクションを呼び出す
    dispatch(openRptAllEntryGuide(params));
  },
});

const DailyListHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'dailyListHeader',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ
  enableReinitialize: true,
})(DailyListHeader);

export default connect(mapStateToProps, mapDispatchToProps)(DailyListHeaderForm);

