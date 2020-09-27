import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, Field, submit } from 'redux-form';
import { connect } from 'react-redux';

import Button from '../../components/control/Button';
import TextBox from '../../components/control/TextBox';
import DropDownPref from '../../components/control/dropdown/DropDownPref';

const formName = 'zipGuideHeader';

class ZipGuideHeaderForm extends React.Component {
  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  render() {
    const { onSubmit, handleSubmit, onClick } = this.props;
    return (
      <div>
        <p>団体コードもしくは団体名称を入力して下さい。</p>
        <form onSubmit={handleSubmit((values) => onSubmit(values))}>
          <Field name="prefcd" component={DropDownPref} addblank />
          <Field name="keyword" component={TextBox} />
          <Button onClick={() => onClick()} value="検索" />
        </form>
      </div>
    );
  }
}

// propTypesの定義
ZipGuideHeaderForm.propTypes = {
  // actionと紐付けされた項目
  onSubmit: PropTypes.func.isRequired,
  onClick: PropTypes.func.isRequired,
  // redux-form化によって紐付けされた項目
  handleSubmit: PropTypes.func.isRequired,
  reset: PropTypes.func.isRequired,
};

const ZipGuideHeader = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
})(ZipGuideHeaderForm);

const mapStateToProps = (state) => ({
  initialValues: state.app.preference.zip.conditions,
});

const mapDispatchToProps = (dispatch) => ({
  onClick: () => {
    dispatch(submit(formName));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(ZipGuideHeader);
