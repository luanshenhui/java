import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import GuideBase from '../../components/common/GuideBase';
import MonshinNyuryoku from './MonshinNyuryoku';
import InterviewHeader from '../../containers/common/InterviewHeaderForm';
import { closeMonshinNyuryokuGuide } from '../../modules/judgement/interviewModule';

const MonshinNyuryokuMain = (props) => {
  const { match } = props;
  const { winmode, rsvno } = match.params;
  return (
    <div>
      {winmode === '1' && (
        <GuideBase {...props} title="生活習慣" usePagination={false}>
          <InterviewHeader rsvno={rsvno} reqwin={0} />
          <MonshinNyuryoku {...props} />
        </GuideBase>
      )}
      {winmode === '0' && (
        <MonshinNyuryoku {...props} />
      )}
    </div>
  );
};
// propTypesの定義
MonshinNyuryokuMain.propTypes = {
  match: PropTypes.shape().isRequired,
  visible: PropTypes.bool,
  onClose: PropTypes.func.isRequired,
};

// defaultPropsの定義
MonshinNyuryokuMain.defaultProps = {
  visible: false,
};

const mapStateToProps = (state) => ({
  visible: state.app.judgement.interview.historyRslList.visible,

});
const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeMonshinNyuryokuGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(MonshinNyuryokuMain);
