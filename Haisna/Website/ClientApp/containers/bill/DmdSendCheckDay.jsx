import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import { connect } from 'react-redux';
import { Field, getFormValues, reduxForm } from 'redux-form';

import PageLayout from '../../layouts/PageLayout';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import DatePicker from '../../components/control/datepicker/DatePicker';

const formName = 'DmdSendCheckDay';
class DmdSendCheckDay extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  // 次へのボタンをクリックしたときの処理
  handleSubmit(values) {
    const { history } = this.props;
    if (!(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/.test(values.sendTime))) {
      // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
      // eslint-disable-next-line no-alert,no-restricted-globals
      if (!confirm('発送日の形式に誤りがあります。')) {
        return;
      }
      return;
    }
    history.replace(`/contents/demand/dmdSendCheck/${moment(values.sendTime).format('YYYY-MM-DD')}`);
  }

  render() {
    const { handleSubmit } = this.props;

    return (
      <PageLayout title="請求書発送確認日設定">
        <form >
          <div>
            <FieldGroup>
              <FieldSet>
                <FieldItem name=""><font color="ff0000">■</font> 発送日:</FieldItem>
                <Field name="sendTime" component={DatePicker} id="" />
              </FieldSet>
              <FieldSet>
                <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="次 へ" />
              </FieldSet>
            </FieldGroup>
          </div>
        </form>
      </PageLayout>
    );
  }
}

// propTypesの定義
DmdSendCheckDay.propTypes = {
  history: PropTypes.shape().isRequired,
  handleSubmit: PropTypes.func.isRequired,
};


const DmdSendCheckDayForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdSendCheckDay);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: {
      sendTime: state.app.bill.demand.demandList.conditions.sendTime,
    },
    formValues,
  };
};


export default connect(mapStateToProps)(DmdSendCheckDayForm);
