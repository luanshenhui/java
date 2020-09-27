/**
 * @file 受診者検索画面検索項目入力部（gdeConsultList.asp）
 */
import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, Field, getFormValues } from 'redux-form';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import moment from 'moment';

import Button from '../../components/control/Button';
import TextBox from '../../components/control/TextBox';
import FieldGroup from '../../components/Field/FieldGroup';
import FieldSet from '../../components/Field/FieldSet';
import FieldItem from '../../components/Field/FieldItem';
import Label from '../../components/control/Label';

// form情報をstateで管理するためにアプリケーションで一意に名前を定義
const form = 'consultationListGuideHeader';

class ConsultationListGuideHeaderForm extends React.Component {
  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  render() {
    const { onSubmit, handleSubmit, formValues } = this.props;
    return (
      <div>
        <form onSubmit={handleSubmit((values) => onSubmit(values))}>
          <FieldGroup>
            <FieldSet>
              <FieldItem>受診日</FieldItem>
              <Label>{ moment(formValues.csldate).format('YYYY/MM/DD') }</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>キー</FieldItem>
              <Field name="keyword" component={TextBox} />
              <Button type="submit" value="検索" />
            </FieldSet>
          </FieldGroup>
        </form>
      </div>
    );
  }
}

// propTypesの定義
ConsultationListGuideHeaderForm.propTypes = {
  // actionと紐付けされた項目
  onSubmit: PropTypes.func.isRequired,
  // redux-form化によって紐付けされた項目
  handleSubmit: PropTypes.func.isRequired,
  reset: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
};

// defaultProps定義
ConsultationListGuideHeaderForm.defaultProps = {
  formValues: {},
};

const ConsultationListGuideHeader = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(ConsultationListGuideHeaderForm);

const mapStateToProps = (state) => {
  const formValues = getFormValues(form)(state);
  return {
    formValues,
    initialValues: state.app.reserve.consult.consultationGuide.conditions,
  };
};

export default withRouter(connect(mapStateToProps)(ConsultationListGuideHeader));
