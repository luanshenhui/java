import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, Field, submit } from 'redux-form';
import { connect } from 'react-redux';

import Button from '../../components/control/Button';
import TextBox from '../../components/control/TextBox';

const formName = 'orgGuideHeader';

class OrgGuideHeaderForm extends React.Component {
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
          <Field name="keyword" component={TextBox} />
          <Button onClick={() => onClick()} value="検索" />
        </form>
      </div>
    );
  }
}

// propTypesの定義
OrgGuideHeaderForm.propTypes = {
  onSubmit: PropTypes.func.isRequired,
  // actionと紐付けされた項目
  onClick: PropTypes.func.isRequired,
  // redux-form化によって紐付けされた項目
  handleSubmit: PropTypes.func.isRequired,
  reset: PropTypes.func.isRequired,
};

const OrgGuideHeader = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
})(OrgGuideHeaderForm);


const mapStateToProps = (state) => ({
  initialValues: { keyword: state.app.preference.organization.organizationGuide.conditions.keyword },
});

const mapDispatchToProps = (dispatch) => ({
  onClick: () => {
    dispatch(submit(formName));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OrgGuideHeader);
