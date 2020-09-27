import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { getFormValues, reduxForm, Field } from 'redux-form';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import SectionBar from '../../components/SectionBar';
import DropDown from '../../components/control/dropdown/DropDown';
import Radio from '../../components/control/Radio';
import { openWebOrgRsvPersonalDetailGuide } from '../../modules/reserve/webOrgRsvModule';
import WebOrgRsvPersonalDetailGuide from './WebOrgRsvPersonalDetailGuide';
// 予約状況
const rsvstatus = [{ value: 0, name: '確定' }, { value: 1, name: '保留' }, { value: 2, name: '未確定' }];
// 宛先
const addrdiv = [{ value: 1, name: '住所（自宅）' }, { value: 2, name: '住所（勤務先）' }, { value: 3, name: '住所（その他）' }];
// 診察券発行
const issuecslticket = [{ value: 1, name: '新規' }, { value: 2, name: '既存' }, { value: 3, name: '再発行' }];

const formName = 'WebOrgRsvPersonal';

class WebOrgRsvPersonal extends React.Component {
  callPersonalDetailWindow() {
    const { onCallPersonalDetailWindow } = this.props;
    onCallPersonalDetailWindow();
  }
  render() {
    const { regflg, frameUsedData } = this.props;
    return (
      <div>
        <SectionBar title="受診付属情報" />
        <FieldGroup itemWidth={200}>
          <FieldSet>
            <FieldItem>予約状況</FieldItem>
            <Field name="rsvstatus" component={DropDown} items={rsvstatus} isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
          </FieldSet>
          <FieldSet>
            <FieldItem>保存時印刷</FieldItem>
            {frameUsedData.regflg === '2' &&
              <div>
                <Field name="prtonsave" component={Radio} checkedValue={0} input={{ value: frameUsedData.prtonsave }} label="なし" />
                <Field name="prtonsave" component={Radio} checkedValue={1} input={{ value: frameUsedData.prtonsave }} label="はがき" />
                <Field name="prtonsave" component={Radio} checkedValue={2} input={{ value: frameUsedData.prtonsave }} label="送付案内" />
              </div>
            }
            {frameUsedData.regflg !== '2' &&
              <div>
                <Field name="prtonsave" component={Radio} checkedValue={0} label="なし" />
                <Field name="prtonsave" component={Radio} checkedValue={1} label="はがき" />
                <Field name="prtonsave" component={Radio} checkedValue={2} label="送付案内" />
              </div>
             }
          </FieldSet>
          <FieldSet>
            <FieldItem>宛先（確認はがき）</FieldItem>
            <Field name="cardaddrdiv" component={DropDown} items={addrdiv} isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
            英文出力
            {frameUsedData.regflg === '2' &&
              <div>
                <Field name="cardouteng" component={Radio} checkedValue={1} input={{ value: frameUsedData.cardouteng }} />有
                <Field name="cardouteng" component={Radio} checkedValue={0} input={{ value: frameUsedData.cardouteng }} />無
              </div>
            }
            {frameUsedData.regflg !== '2' &&
              <div>
                <Field name="cardouteng" component={Radio} checkedValue={1} />有
                <Field name="cardouteng" component={Radio} checkedValue={0} />無
              </div>
            }
          </FieldSet>
          <FieldSet>
            <FieldItem>宛先（一式書式）</FieldItem>
            <Field name="formaddrdiv" component={DropDown} items={addrdiv} isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
            英文出力
            {frameUsedData.regflg === '2' &&
              <div>
                <Field name="formouteng" component={Radio} checkedValue={1} input={{ value: frameUsedData.formouteng }} />有
                <Field name="formouteng" component={Radio} checkedValue={0} input={{ value: frameUsedData.formouteng }} />無
              </div>
            }
            {frameUsedData.regflg !== '2' &&
              <div>
                <Field name="formouteng" component={Radio} checkedValue={1} />有
                <Field name="formouteng" component={Radio} checkedValue={0} />無
              </div>
            }
          </FieldSet>
          <FieldSet>
            <FieldItem>宛先（成績表）</FieldItem>
            <Field name="reportaddrdiv" component={DropDown} items={addrdiv} isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
            英文出力
            {frameUsedData.regflg === '2' &&
              <div>
                <Field name="reportouteng" component={Radio} checkedValue={1} input={{ value: frameUsedData.reportouteng }} />有
                <Field name="reportouteng" component={Radio} checkedValue={0} input={{ value: frameUsedData.reportouteng }} />無
              </div>
            }
            {frameUsedData.regflg !== '2' &&
              <div>
                <Field name="reportouteng" component={Radio} checkedValue={1} />有
                <Field name="reportouteng" component={Radio} checkedValue={0} />無
              </div>
            }
          </FieldSet>
          <FieldSet>
            <FieldItem>診察券発行</FieldItem>
            <Field name="issuecslticket" component={DropDown} items={issuecslticket} addblank blankname="" isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
          </FieldSet>
          <div style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>
            <a role="presentation" onClick={() => (this.callPersonalDetailWindow())} >
              その他の付属情報を{regflg !== '1' ? '見る' : '入力'}
            </a>
          </div>
        </FieldGroup>
        <WebOrgRsvPersonalDetailGuide />
      </div>
    );
  }
}

const WebOrgRsvPersonalForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(WebOrgRsvPersonal);

WebOrgRsvPersonal.propTypes = {
  onCallPersonalDetailWindow: PropTypes.func.isRequired,
  frameUsedData: PropTypes.shape(),
  regflg: PropTypes.number,
};


WebOrgRsvPersonal.defaultProps = {
  regflg: null,
  frameUsedData: null,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: {
      rsvstatus: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.rsvstatus,
      prtonsave: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.prtonsave,
      cardaddrdiv: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.cardaddrdiv,
      formaddrdiv: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.formaddrdiv,
      reportaddrdiv: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.reportaddrdiv,
      issuecslticket: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.issuecslticket,
      formouteng: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.formouteng,
      reportouteng: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.reportouteng,
      cardouteng: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.cardouteng,
    },
    formValues,
    regflg: state.app.reserve.webOrgRsv.webOrgRsvList.regflg,
    frameUsedData: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onCallPersonalDetailWindow() {
    dispatch(openWebOrgRsvPersonalDetailGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(WebOrgRsvPersonalForm);
