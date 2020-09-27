import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Link, withRouter } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';
import PageLayout from '../../layouts/PageLayout';
import MessageBanner from '../../components/MessageBanner';

import { FieldItem, FieldGroup, FieldSet } from '../../components/Field';

import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import TextBox from '../../components/control/TextBox';
import { getDispatchSeqRequest, deleteDispatchRequest, checkValueSendCheckDayRequest, updateDispatchRequest } from '../../modules/bill/demandModule';


let message = '';
class DmdSendCheck extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.sendTime = match.params.sendTime;
    this.mode = match.params.mode;
    this.sendYear = match.params.sendYear;
    this.sendMonth = match.params.sendMonth;
    this.sendDay = match.params.sendDay;
    this.action = match.params.action;
    this.billNo = match.params.billNo;
    this.delFlg = match.params.delFlg;
    this.closeDate = match.params.closeDate;
    this.dispatchDate = match.params.dispatchDate;
    this.max = match.params.max;
    this.confirm = match.params.confim;
  }

  componentWillMount() {
  }

  handleCancelClick() {
    const { onDelete, history, match } = this.props;
    onDelete(match.params, () => history.replace('/contents/preference/bill'));
  }


  render() {
    const { getDispatchSeq, checkValueSendCheckDay, updateDispatch } = this.props;
    checkValueSendCheckDay(this.sendYear, this.sendMonth, this.sendDay);
    if (this.action === 'submit') {
      if (this.billNo === undefined) {
        message = '請求書番号を指定してください';
      }
      if (this.billNo.split('').length !== 14) {
        message = '請求書番号が不正です';
        this.billNo = undefined;
      } else if (/^[0-9]+.?[0-9]*$/.test(this.billNo)) {
        message = '請求書番号が不正です';
        this.billNo = undefined;
      }
      if (/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/.test(this.closeDate)) {
        message = '請求書番号が不正です';
      } else {
        getDispatchSeq(this.billNo);
        message = '発送情報の取得に失敗しました';
      }
      if (this.delFlg === 1) {
        message = '取消伝票は発送できません';
      }
      if (this.closeDate > this.dispatchDate) {
        message = '発送日は締め日以降の日付を入力してください。';
      }
      if (this.mode === undefined) {
        if (this.max === 0) {
          this.mode = 'insert';
        } else {
          this.confirm = 1;
        }
      }
      if (this.mode === 'cancel') {
        this.billNo = undefined;
      } else if (this.mode === 'update' && this.max !== 0) {
        updateDispatch(this.billNo, this.seq, this.data);
        message = '発送情報は更新できませんでした';
        this.billNo = undefined;
      }
    }
    return (
      <PageLayout title="請求書発送確認" >
        <div style={{ width: 200, height: 200, float: 'left' }} />
        <form>
          <div>
            <MessageBanner messages={message} />
            <FieldGroup>
              <FieldSet>
                <Label><font size="6">発送日：</font></Label>
                <Label><font size="6" color="#ff4500"><b>{moment(this.sendTime).format('YYYY/MM/DD')}</b></font></Label>
                <Label><font size="6">の確認処理を行います。</font></Label>
              </FieldSet>
              {this.confirm !== 1 && (
                <FieldSet>
                  <FieldItem>BarCode:</FieldItem>
                  <Field name="aa" component={TextBox} id="" style={{ width: 180 }} />
                </FieldSet>
              )}
              {this.confirm === 1 && (
                <FieldSet>
                  <Label>発送確認ずみです。</Label>
                  <Button onClick={this.handleCancelClick} value="キャンセルします" />
                  <Button onClick={this.handleUpdateClick} value="発送日を変更します" />
                  <Button onClick={this.handleInsertClick} value="発送日を追加します" />
                </FieldSet>
              )}

              {this.action === 'submitend' && (
                <FieldGroup>
                  <FieldSet>
                    <Label>発送確認完了:</Label>
                    <Field name="" component={TextBox} id="" style={{ width: 180 }} />
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>請求書No:</FieldItem>
                    <Field name="this.billNo" component={TextBox} id="" />
                  </FieldSet>
                  <FieldSet>
                    <Field name="this.orgName" component={TextBox} id="" />
                  </FieldSet>
                  <FieldSet>
                    <Field name="this.disTotal" component={TextBox} id="" />
                  </FieldSet>
                </FieldGroup>
              )}
              {this.billNo !== undefined && (
                <FieldSet>
                  <Link to={`/contents/preference/bill/dmdBurdenModify/${this.billNo}`}>請求情報を参照</Link>
                </FieldSet>
              )}

            </FieldGroup>
          </div>
        </form>
      </PageLayout>
    );
  }
}


// propTypesの定義
DmdSendCheck.propTypes = {
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  onDelete: PropTypes.func.isRequired,
  checkValueSendCheckDay: PropTypes.func.isRequired,
  getDispatchSeq: PropTypes.func.isRequired,
  updateDispatch: PropTypes.func.isRequired,
};

const DmdSendCheckForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'DmdSendCheck',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdSendCheck);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  billNo: state.app.bill.demand.demandList.billNo,
});

const mapDispatchToProps = (dispatch) => ({
  getDispatchSeq: (billNo) => {
    dispatch(getDispatchSeqRequest(billNo));
  },
  checkValueSendCheckDay: (params) => {
    dispatch(checkValueSendCheckDayRequest(params));
  },
  updateDispatch: (billNo, seq) => {
    dispatch(updateDispatchRequest(billNo, seq));
  },
  onDelete: (params, redirect) =>
    dispatch(deleteDispatchRequest({ params, redirect })),
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(DmdSendCheckForm));
