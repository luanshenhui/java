import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import GuideBase from '../../components/common/GuideBase';
import RslUpdateHistory from './RslUpdateHistory';
import InterviewHeader from '../../containers/common/InterviewHeaderForm';
import { closeUpdateLogGuide } from '../../modules/judgement/interviewModule';

const RslUpdateHistoryMain = (props) => {
  const { conditions, match } = props;
  const { params } = match;
  return (
    <div>
      {params.winmode === '1' && (
        <GuideBase {...props} title="変更履歴" page={conditions.page} limit={Number(conditions.limit)} usePagination>
          <InterviewHeader rsvno={params.rsvno} reqwin={0} />
          <RslUpdateHistory {...props} />
        </GuideBase>
       )}
      {params.winmode === '0' && (
        <RslUpdateHistory {...props} />
      )}
    </div>
  );
};
// propTypesの定義
RslUpdateHistoryMain.propTypes = {
  match: PropTypes.shape().isRequired,
  conditions: PropTypes.shape().isRequired,
  visible: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  conditions: state.app.judgement.interview.rslUpdateHistoryList.conditions,
  visible: state.app.judgement.interview.rslUpdateHistoryList.visible,
});

const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeUpdateLogGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(RslUpdateHistoryMain);
