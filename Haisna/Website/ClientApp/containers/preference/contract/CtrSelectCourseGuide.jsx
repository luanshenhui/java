import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { reduxForm, initialize } from 'redux-form';
import * as contants from '../../../constants/common';
import Button from '../../../components/control/Button';
import CtrSelectCourseBody from './CtrSelectCourseBody';
import { closeCtrCreateWizardGuide } from '../../../modules/preference/contractModule';

const formName = 'ctrCreateForm';

class CtrSelectCourseGuide extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentDidMount() {
    const { onLoad } = this.props;
    onLoad();
  }

  // 契約コースの選択次へ
  handleSubmit(values) {
    const { onSubmit } = this.props;
    onSubmit(values);
  }

  render() {
    const { handleSubmit, onClose, params } = this.props;
    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <div>
          <div>
            <Button onClick={onClose} value="キャンセル" />
            <Button type="submit" className="next" value="次　へ" />
          </div>
          <CtrSelectCourseBody actmode={contants.OPMODE_COPY} params={params} />
        </div>
      </form>
    );
  }
}
const CtrCreateForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(CtrSelectCourseGuide);

// プロパティの型を定義する
CtrSelectCourseGuide.propTypes = {
  onClose: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  params: PropTypes.shape().isRequired,
  handleSubmit: PropTypes.func.isRequired,
};

const mapDispatchToProps = (dispatch, props) => ({
  // 画面を初期化
  onLoad: () => {
    const { curPage, initialValues } = props;
    if (curPage === 1) {
      dispatch(initialize(formName, initialValues));
    }
  },
  // 次へボタン押下時の処理
  onSubmit: (data) => {
    if (data.cscd === undefined || data.cscd === null) {
      return;
    }
    props.onNext();
  },
  // クローズ時の処理
  onClose: () => {
    const { initialValues } = props;
    dispatch(initialize(formName, initialValues));
    // 閉じるアクションを呼び出す
    dispatch(closeCtrCreateWizardGuide());
  },
});

export default connect(() => ({}), mapDispatchToProps)(CtrCreateForm);
