import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, Field, submit } from 'redux-form';
import { connect } from 'react-redux';

import Button from '../../components/control/Button';
import DropDownItemClass from '../../components/control/dropdown/DropDownItemClass';

const formName = 'grpGuideHeader';

class GrpGuideHeaderForm extends React.Component {
  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  render() {
    const { onSubmit, handleSubmit, onClick } = this.props;
    return (
      <div>
        <p>検査項目分類を選択して下さい。</p>
        <form onSubmit={handleSubmit((values) => onSubmit(values))}>
          <Field name="classcd" component={DropDownItemClass} addblank blankname="全て" />
          <Button onClick={() => onClick()} value="検索" />
        </form>
      </div>
    );
  }
}

// propTypesの定義
GrpGuideHeaderForm.propTypes = {
  // actionと紐付けされた項目
  onSubmit: PropTypes.func.isRequired,
  onClick: PropTypes.func.isRequired,
  // redux-form化によって紐付けされた項目
  handleSubmit: PropTypes.func.isRequired,
  reset: PropTypes.func.isRequired,
};

const GrpGuideHeader = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
})(GrpGuideHeaderForm);

const mapStateToProps = (state) => ({
  initialValues: state.app.preference.group.groupGuide.conditions,
});

const mapDispatchToProps = (dispatch) => ({
  onClick: () => {
    dispatch(submit(formName));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(GrpGuideHeader);
