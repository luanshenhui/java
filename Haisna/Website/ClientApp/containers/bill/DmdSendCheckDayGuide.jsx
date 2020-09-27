import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { Field, getFormValues, reduxForm, blur } from 'redux-form';
import GuideBase from '../../components/common/GuideBase';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import DatePicker from '../../components/control/datepicker/DatePicker';
import {
  closeDmdSendCheckDayGuide,
  updateDispatchRequest,
  deleteDispatchRequest,
} from '../../modules/bill/demandModule';

const Font = styled.span`
    height: 500px;
`;
const formName = 'DmdSendCheckDay';
class DmdSendCheckDay extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    const { visible, setValues, params, dispatchdate } = this.props;
    if (nextProps.visible && !visible && dispatchdate) {
      setValues('dispatchdate', params.dispatchdate);
    }
  }
  // 確定のボタンをクリックしたときの処理
  handleSubmit = (values) => {
    const { onSubmit, params } = this.props;
    onSubmit({ ...params, ...values }, values.dispatchdate);
  }

  // 確定のボタンをタンクリック時の処理
  handleCancelClick() {
    const { onClose } = this.props;
    onClose();
  }

  // 削除
  handleRemoveClick() {
    const { onDelete, params } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('指定された発送情報を削除します。よろしいですか')) {
      return;
    }
    onDelete(params);
  }

  render() {
    const { params, formValues } = this.props;
    return (
      <GuideBase {...this.props} title="請求書発送確認日修正" usePagination>
        <form >
          <Font>
            <div>
              <FieldGroup>
                <FieldSet>
                  <FieldItem name=""><font color="ff0000">■</font> 発送日:</FieldItem>
                  <Field name="dispatchdate" component={DatePicker} id="" />
                </FieldSet>
                <FieldSet>
                  {params.delflg !== 1 && (
                    <Button onClick={this.handleRemoveClick} value="削除" />
                  )}
                  {params.delflg !== 1 && (
                    <Button onClick={() => this.handleSubmit(formValues)} value="確定" />
                  )}
                  <Button onClick={this.handleCancelClick} value="キャンセルする " />
                </FieldSet>
              </FieldGroup>
            </div>
          </Font>
        </form>
      </GuideBase>
    );
  }
}

// propTypesの定義
DmdSendCheckDay.propTypes = {
  formValues: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  params: PropTypes.shape().isRequired,
  onClose: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  billNo: PropTypes.string.isRequired,
  onDelete: PropTypes.string.isRequired,
  conditions: PropTypes.shape().isRequired,
  setValues: PropTypes.func.isRequired,
  dispatchdate: PropTypes.string.isRequired,
  visible: PropTypes.bool.isRequired,
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
    params: state.app.bill.demand.dmdSendCheckDay.params,
    visible: state.app.bill.demand.dmdSendCheckDay.visible,
    dispatchdate: state.app.bill.demand.dmdSendCheckDay.params.dispatchdate,
    formValues,
  };
};

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeDmdSendCheckDayGuide());
  },
  onSubmit: (params, dispatchdate) => {
    // 登録・修正
    dispatch(updateDispatchRequest({ params, dispatchdate }));
  },
  onDelete: (params) => {
    dispatch(deleteDispatchRequest(params));
  },
  setValues: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(DmdSendCheckDayForm);
