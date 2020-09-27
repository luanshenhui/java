import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { reduxForm, getFormValues } from 'redux-form';

import { getTargetFollowListRequest, openFollowInfoGuide, openFollowReqEditGuideRequest, openFollowInfoEditGuideRequest } from '../../modules/followup/followModule';
import MessageBanner from '../../components/MessageBanner';
import Pagination from '../../components/Pagination';
import PageLayout from '../../layouts/PageLayout';
import FollowInfoListHeaderFrom from './FollowInfoListHeaderFrom';
import FollowInfoListBody from './FollowInfoListBody';
import FollowinfoTop from '../judgement/FollowinfoTop';
import FollowInfoEditGuide from './FollowInfoEditGuide';
import FollowReqEditGuide from './FollowReqEditGuide';

const formName = 'FollowInfoList';

const Color = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const searchRet = (actions, message, totalcount, formValues) => {
  const res = [];
  let reactid = 0;
  if (actions === 'search') {
    if (formValues !== undefined && formValues.startCslDate !== null) {
      res.push('「');
      res.push(<Color key={`startCslDate_${reactid}`}>{moment(formValues.startCslDate, 'YYYYMMDD').format('YYYY年M月D日')}</Color>);
      if (formValues !== undefined && formValues.endCslDate !== '' && formValues.endCslDate !== null) {
        res.push(<Color key={`endCslDate_${reactid}`}>～{moment(formValues.endCslDate, 'YYYYMMDD').format('YYYY年M月D日')}</Color>);
        res.push('」');
      } else {
        res.push('」');
      }
      res.push(<span key={`span_${reactid}`}>のフォローアップ対象者一覧を表示しています。<br /></span>);
    }
    res.push(<span key={`p_${reactid}`}>検索結果は<Color>{totalcount}</Color>件ありました。</span>);
    res.push('　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　');
    res.push('面接：面接支援  依頼：依頼状作成  結果：結果入力');
  }
  reactid += 1;
  return res;
};

const itemInfo = (followItem) => {
  let res;
  for (let i = 0; i < followItem.length; i += 1) {
    if (i === 0) {
      res = followItem[i].itemname;
    } else {
      res += `、${followItem[i].itemname}`;
    }
  }
  return res;
};

const FollowInfoList = (props) => {
  const { targetFollowList, conditions, totalcount, message, onOpenFollowInfoGuide, onOpenMenResultGuide,
    onOpenFollowReqEditGuide, onOpenFollowInfoEditGuide, onSearch, followItem, actions, formValues } = props;
  return (
    <PageLayout title="フォローアップ検索">
      <div>
        <FollowInfoListHeaderFrom />
        <div style={{ marginTop: '30px' }}>
          <div style={{ marginBottom: '30px' }}>
            ※フォロー対象検査項目:
            {itemInfo(followItem)}
          </div>
          <MessageBanner messages={message} />
          {searchRet(actions, message, totalcount, formValues)}
          {actions === 'search' &&
            <FollowInfoListBody
              data={targetFollowList}
              onOpenFollowInfoGuide={onOpenFollowInfoGuide}
              onOpenMenResultGuide={onOpenMenResultGuide}
              onOpenFollowReqEditGuide={onOpenFollowReqEditGuide}
              onOpenFollowInfoEditGuide={onOpenFollowInfoEditGuide}
            />
          }
          {totalcount > conditions.pageMaxLine && (
            <Pagination
              startPos={(conditions.startPos - 1) * conditions.pageMaxLine + 1}
              rowsPerPage={parseInt(conditions.pageMaxLine, 10)}
              totalCount={totalcount}
              onSelect={(startPos) => { onSearch({ ...conditions, startPos }); }}
            />
          )}
          <FollowinfoTop match={{ params: { winmode: '1' } }} />
          <FollowInfoEditGuide />
          <FollowReqEditGuide />
        </div>
      </div>
    </PageLayout>
  );
};

const FollowInfoListFrom = reduxForm({
  form: formName,
})(FollowInfoList);

// propTypesの定義
FollowInfoList.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  targetFollowList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  totalcount: PropTypes.number.isRequired,
  onOpenFollowInfoGuide: PropTypes.func.isRequired,
  onOpenMenResultGuide: PropTypes.func.isRequired,
  onOpenFollowReqEditGuide: PropTypes.func.isRequired,
  onOpenFollowInfoEditGuide: PropTypes.func.isRequired,
  onSearch: PropTypes.func.isRequired,
  followItem: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  actions: PropTypes.string.isRequired,
  formValues: PropTypes.shape(),
  conditions: PropTypes.shape().isRequired,
};

FollowInfoList.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    // 検索条件
    message: state.app.followup.follow.followInfoList.message,
    targetFollowList: state.app.followup.follow.followInfoList.targetFollowList,
    totalcount: state.app.followup.follow.followInfoList.totalcount,
    followItem: state.app.followup.follow.followInfoList.followItem,
    actions: state.app.followup.follow.followInfoList.actions,
    conditions: state.app.followup.follow.followInfoList.conditions,
    initialValues: {
      startCslDate: '2016/07/15',
      endCslDate: '2016/11/01',
      pageMaxLine: 10,
      judClassCd: '',
      equipDiv: '',
      confirmDiv: '',
      addUser: '',
      perId: '',
      userName: '',
      perName: '',
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    dispatch(getTargetFollowListRequest(conditions));
  },
  // フォローアップ照会画面呼び出し
  onOpenFollowInfoGuide: (rsvno) => {
    dispatch(openFollowInfoGuide(rsvno));
  },
  // 検査結果画面呼び出し
  onOpenMenResultGuide: () => {
    // TODO
  },
  // フォロー依頼状作成画面呼び出し
  onOpenFollowReqEditGuide: (rsvno, judclasscd) => {
    dispatch(openFollowReqEditGuideRequest({ rsvno, judclasscd }));
  },
  // フォローアップ情報編集画面呼び出し
  onOpenFollowInfoEditGuide: (rsvno, judclasscd) => {
    dispatch(openFollowInfoEditGuideRequest({ rsvno, judclasscd }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowInfoListFrom);
