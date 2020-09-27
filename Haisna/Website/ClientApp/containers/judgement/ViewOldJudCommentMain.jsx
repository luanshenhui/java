import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import GuideBase from '../../components/common/GuideBase';
import ViewOldJudCommentList from './ViewOldJudCommentList';
import InterviewHeader from '../../containers/common/InterviewHeaderForm';
import { closeViewOldJudCommentGuide } from '../../modules/judgement/interviewModule';

const ViewOldJudCommentMain = (props) => {
  const { match } = props;
  const { winmode, rsvno } = match.params;
  return (
    <div>
      {(winmode === '1') && (
        <GuideBase {...props} title="過去総合コメント一覧" usePagination={false}>
          <InterviewHeader rsvno={rsvno} reqwin={0} />
          <ViewOldJudCommentList {...props} />
        </GuideBase>
      )}
      {(winmode === '0') && (
        <ViewOldJudCommentList {...props} />
      )}
    </div>
  );
};
// propTypesの定義
ViewOldJudCommentMain.propTypes = {
  match: PropTypes.shape().isRequired,
  visible: PropTypes.bool,
  onClose: PropTypes.func.isRequired,
};

// defaultPropsの定義
ViewOldJudCommentMain.defaultProps = {
  visible: false,
};

const mapStateToProps = (state) => ({
  visible: state.app.judgement.interview.viewOldJudCommentList.visible,

});
const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeViewOldJudCommentGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(ViewOldJudCommentMain);
