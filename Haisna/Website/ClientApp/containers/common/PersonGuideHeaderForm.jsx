import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { reduxForm, Field, submit } from 'redux-form';

import Button from '../../components/control/Button';
import TextBox from '../../components/control/TextBox';

const formName = 'personGuideHeader';

class PersonGuideHeaderForm extends React.Component {
  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }
  render() {
    const { onSubmit, handleSubmit, onClick } = this.props;
    return (
      <div>
        <form onSubmit={handleSubmit((values) => onSubmit(values))}>
          <label htmlFor="label1">検索条件: </label>
          <Field name="keyword" component={TextBox} />
          <label htmlFor="label2">生年月日: </label>
          {/*
          <Field name="year" component={DropDown} />
          <Field name="month" component={DropDown} />
          <Field name="day" component={DropDown} />
          <label htmlFor="label3">性別: </label>
          <Field name="sex" component={DropDown} />
          <label htmlFor="label4">住所: </label>
          <Field name="address" component={DropDown} />
          <Field name="address" component={TextBox} />
          */}
          <Button onClick={() => onClick()} value="検索" />
        </form>
      </div>
    );
  }
}

// propTypesの定義
PersonGuideHeaderForm.propTypes = {
  // actionと紐付けされた項目
  onSubmit: PropTypes.func.isRequired,
  onClick: PropTypes.func.isRequired,
  // redux-form化によって紐付けされた項目
  handleSubmit: PropTypes.func.isRequired,
  reset: PropTypes.func.isRequired,
};

const personGuideHeader = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
})(PersonGuideHeaderForm);

const mapStateToProps = () => ({});

const mapDispatchToProps = (dispatch) => ({
  onClick: () => {
    dispatch(submit(formName));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(personGuideHeader);
