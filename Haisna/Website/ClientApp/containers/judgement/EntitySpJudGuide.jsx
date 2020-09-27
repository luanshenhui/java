import React from 'react';
import { withRouter } from 'react-router-dom';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import * as Contants from '../../constants/common';
import Button from '../../components/control/Button';
import GuideBase from '../../components/common/GuideBase';
import Radio from '../../components/control/Radio';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../components/Field';
import { closeEntitySpJudGuide, updateEntitySpJudRequest } from '../../modules/judgement/specialInterviewModule';
import MessageBanner from '../../components/MessageBanner';

const formName = 'EntitySpJudGuideForm';

class EntitySpJudGuide extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 保存
  handleSubmit(rsldata) {
    const { match, onSubmit } = this.props;
    // onSubmitアクションの引数として渡す
    onSubmit(match.params, rsldata);
  }

  render() {
    const { message, handleSubmit, onClose } = this.props;
    return (
      <GuideBase {...this.props} title="特定保健指導区分登録" usePagination={false} >
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div>
            <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
            <Button onClick={() => { onClose(); }} value="キャンセル" />
          </div>
          <MessageBanner messages={message} />
          <FieldGroup itemWidth={118}>
            <FieldSet>
              <FieldItem>特定保健指導 </FieldItem>
              <FieldValueList>
                <FieldValue>
                  <Field name="rsldata" component={Radio} checkedValue={1} label="対象外" />
                  <Field name="rsldata" component={Radio} checkedValue={2} label="対象" />
                </FieldValue>
              </FieldValueList>
            </FieldSet>
          </FieldGroup>
        </form>
      </GuideBase>
    );
  }
}

const EntitySpJudGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(EntitySpJudGuide);

EntitySpJudGuide.propTypes = {
  match: PropTypes.shape().isRequired,
  visible: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  rsldata: PropTypes.number,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
};
// defaultPropsの定義
EntitySpJudGuide.defaultProps = {
  rsldata: null,
};

const mapStateToProps = (state) => ({
  initialValues: {
    rsldata: state.app.judgement.specialInterview.entitySpJudGuide.rsldata,
  },
  // 可視状態
  visible: state.app.judgement.specialInterview.entitySpJudGuide.visible,
  message: state.app.judgement.specialInterview.entitySpJudGuide.message,
});

const mapDispatchToProps = (dispatch) => ({

  onSubmit: (params, seldata) => {
    const { rsvno } = params;
    const { rsldata } = seldata;
    const results = [];
    results.push({ itemcd: Contants.GUIDANCE_ITEMCD, suffix: Contants.GUIDANCE_SUFFIX, result: rsldata });
    dispatch(updateEntitySpJudRequest({ rsvno, results }));
  },

  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeEntitySpJudGuide());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(EntitySpJudGuideForm));
