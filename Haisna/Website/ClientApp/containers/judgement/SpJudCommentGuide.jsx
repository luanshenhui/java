import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import Button from '../../components/control/Button';
import GuideBase from '../../components/common/GuideBase';
import SpJudCommentGuideBody from './SpJudCommentGuideBody';

import { updateSpecialJudCmtRequest, closeSpecialJudCmtGuide } from '../../modules/judgement/specialInterviewModule';

const formName = 'spJudCommentGuideForm';

class SpJudCommentGuide extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 保存
  handleSubmit() {
    const { match, onSubmit, judcmtdata } = this.props;
    // onSubmitアクションの引数として渡す
    onSubmit(match.params, { judcmtdata });
  }

  render() {
    const { handleSubmit } = this.props;
    return (
      <GuideBase {...this.props} title="特定健診判定コメント" usePagination={false} >
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
          <SpJudCommentGuideBody {...this.props} />
        </form>
      </GuideBase>
    );
  }
}

const SpJudCommentGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(SpJudCommentGuide);

SpJudCommentGuide.propTypes = {
  match: PropTypes.shape().isRequired,
  visible: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  judcmtdata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.judgement.specialInterview.spJudCommentGuide.visible,
  judcmtdata: state.app.judgement.specialInterview.spJudCommentGuide.judcmtdata,
});

const mapDispatchToProps = (dispatch) => ({

  onSubmit: (params, data) => {
    dispatch(updateSpecialJudCmtRequest({ params, data }));
  },

  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeSpecialJudCmtGuide());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(SpJudCommentGuideForm));
