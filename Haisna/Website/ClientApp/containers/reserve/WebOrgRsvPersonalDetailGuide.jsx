import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import { withRouter } from 'react-router-dom';
import { getFormValues, reduxForm, Field, blur } from 'redux-form';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import GuideBase from '../../components/common/GuideBase';
import DropDown from '../../components/control/dropdown/DropDown';
import Radio from '../../components/control/Radio';
import TextBox from '../../components/control/TextBox';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import GuideButton from '../../components/GuideButton';
import Chip from '../../components/Chip';
import MessageBanner from '../../components/MessageBanner';
import { openPersonGuide } from '../../modules/preference/personModule';
import PersonGuide from '../../containers/common/PersonGuide';
import { perDetailSave, closeWebOrgRsvPersonalDetailGuide } from '../../modules/reserve/webOrgRsvModule';
// 予約状況
const rsvstatus = [{ value: 0, name: '確定' }, { value: 1, name: '保留' }, { value: 2, name: '未確定' }];
// 宛先
const addrdiv = [{ value: 1, name: '住所（自宅）' }, { value: 2, name: '住所（勤務先）' }, { value: 3, name: '住所（その他）' }];
// 診察券発行
const issuecslticket = [{ value: 1, name: '新規' }, { value: 2, name: '既存' }, { value: 3, name: '再発行' }];
// ボランティア
const volunteer = [{ value: 0, name: '利用なし' }, { value: 1, name: '通訳要' }, { value: 2, name: '介護要' }, { value: 3, name: '通訳＆介護要' }, { value: 4, name: '車椅子要' }];
// 利用券回収
const collectticket = [{ value: 0, name: '未回収' }, { value: 1, name: '回収済' }];
// 請求書出力
const billprint = [{ value: 0, name: '指定なし' }, { value: 1, name: '本人' }, { value: 2, name: '家族' }];


const formName = 'WebOrgRsvPersonalDetailGuide';

class WebOrgRsvPersonalDetailGuide extends React.Component {
  constructor(props) {
    super(props);
    this.onPersonalDetailSaveClick = this.onPersonalDetailSaveClick.bind(this);
    this.selectedPerson = this.selectedPerson.bind(this);
    this.delPerson = this.delPerson.bind(this);
  }
  onPersonalDetailSaveClick() {
    const { formValues, frameUsedData, onPersonalDetailSave } = this.props;

    Object.assign(frameUsedData, formValues);

    onPersonalDetailSave(frameUsedData);
  }

  // 個人選択時の処理
  selectedPerson(data) {
    const { setValue } = this.props;
    let value = '';
    if (data.lastname !== null) {
      value = `${value}${data.lastname}`;
    }
    if (data.firstname !== null) {
      value = `${value}${data.firstname}`;
    }
    setValue('introductor', data.perid);
    setValue('introductname', value);
  }

  delPerson() {
    const { setValue } = this.props;
    setValue('introductor', '');
    setValue('introductname', '');
  }

  render() {
    const { formValues, onClose, message, frameUsedData, orglukes, consultDetail, onOpenPersonGuide } = this.props;
    return (
      <GuideBase {...this.props} title="受診付属情報" usePagination={false} >
        {frameUsedData.regflg !== '2' &&
          <Button onClick={this.onPersonalDetailSaveClick} value="保存" />
        }
        <Button onClick={onClose} value="キャンセル" />
        <MessageBanner messages={message} />
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
            <FieldItem>住所（自宅）</FieldItem>
            {formValues && formValues.zipcd !== undefined && formValues.zipcd[0] !== '' && formValues.zipcd[0] !== null &&
              `${formValues.zipcd[0].substring(0, 3)}-${formValues.zipcd[0].substring(3, 7)}`}
            &nbsp;&nbsp;
            {formValues && formValues.address1 !== undefined && formValues.address1[0]}
            {formValues && formValues.address2 !== undefined && formValues.address2[0]}
            {formValues && formValues.prefname !== undefined && formValues.prefname[0]}
            {formValues && formValues.cityname !== undefined && formValues.cityname[0]}
          </FieldSet>
          <FieldSet>
            <FieldItem>住所（勤務先）</FieldItem>
            {formValues && formValues.zipcd !== undefined && formValues.zipcd[1] !== '' && formValues.zipcd[1] !== null &&
              `${formValues.zipcd[1].substring(0, 3)}-${formValues.zipcd[1].substring(3, 7)}`}
            &nbsp;&nbsp;
            {formValues && formValues.address1 !== undefined && formValues.address1[1]}
            {formValues && formValues.address2 !== undefined && formValues.address2[1]}
            {formValues && formValues.prefname !== undefined && formValues.prefname[1]}
            {formValues && formValues.cityname !== undefined && formValues.cityname[1]}
          </FieldSet>
          <FieldSet>
            <FieldItem>住所（その他）</FieldItem>
            {formValues && formValues.zipcd !== undefined && formValues.zipcd[2] !== '' && formValues.zipcd[2] !== null &&
              `${formValues.zipcd[2].substring(0, 3)}-${formValues.zipcd[2].substring(3, 7)}`}
            &nbsp;&nbsp;
            {formValues && formValues.address1 !== undefined && formValues.address1[2]}
            {formValues && formValues.address2 !== undefined && formValues.address2[2]}
            {formValues && formValues.prefname !== undefined && formValues.prefname[2]}
            {formValues && formValues.cityname !== undefined && formValues.cityname[2]}
          </FieldSet>
          <FieldSet>
            <FieldItem>ボランティア</FieldItem>
            <Field name="volunteer" component={DropDown} items={volunteer} isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
          </FieldSet>
          <FieldSet>
            <FieldItem>ボランティア名</FieldItem>
            <Field name="volunteername" component={TextBox} maxLength={25} disabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
          </FieldSet>
          <FieldSet>
            <FieldItem>利用券回収</FieldItem>
            <Field name="collectticket" component={DropDown} items={collectticket} isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
          </FieldSet>
          <FieldSet>
            <FieldItem>診察券発行</FieldItem>
            <Field name="issuecslticket" component={DropDown} items={issuecslticket} isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
          </FieldSet>
          {orglukes && orglukes.billcsldiv !== null && orglukes.reptcsldiv !== null &&
            <FieldSet>
              <FieldItem><span style={{ color: 'red' }}>請求書出力</span></FieldItem>
              <Field name="billprint" component={DropDown} items={billprint} isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
            </FieldSet>
          }
          <FieldSet>
            <FieldItem>保険証記号</FieldItem>
            <Field name="isrsign" component={TextBox} maxLength={16} disabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
          </FieldSet>
          <FieldSet>
            <FieldItem>保険証番号</FieldItem>
            <Field name="isrno" component={TextBox} maxLength={16} disabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
          </FieldSet>
          <FieldSet>
            <FieldItem>保険者番号</FieldItem>
            <Field name="isrmanno" component={TextBox} maxLength={16} disabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
          </FieldSet>
          <FieldSet>
            <FieldItem>社員番号</FieldItem>
            <Field name="empno" component={TextBox} maxLength={12} disabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
          </FieldSet>
          <FieldSet>
            <FieldItem>紹介者名</FieldItem>
            {frameUsedData.regflg === '1' &&
              <GuideButton
                onClick={() => { onOpenPersonGuide(this.selectedPerson); }}
              />
            }
            <PersonGuide />
            {frameUsedData.regflg === '1' &&
              <Chip
                onDelete={() => { this.delPerson(); }}
                label={formValues && formValues.introductname}
              />
            }
            {frameUsedData.regflg !== '1' &&
              <span>
                {formValues && formValues.introductname}
              </span>
            }
          </FieldSet>
          <FieldSet>
            <FieldItem>前回受診日</FieldItem>
            <Label>
              {consultDetail !== null && consultDetail.lastcsldate !== null ? moment(consultDetail.lastcsldate).format('YYYY年M月D日') : ''}
            </Label>
          </FieldSet>
        </FieldGroup>
      </GuideBase>
    );
  }
}

const WebOrgRsvPersonalDetailGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(WebOrgRsvPersonalDetailGuide);

WebOrgRsvPersonalDetailGuide.propTypes = {
  frameUsedData: PropTypes.shape(),
  formValues: PropTypes.shape(),
  orglukes: PropTypes.shape(),
  consultDetail: PropTypes.shape(),
  message: PropTypes.arrayOf(PropTypes.string),
  onClose: PropTypes.func.isRequired,
  onPersonalDetailSave: PropTypes.func.isRequired,
  onOpenPersonGuide: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  delPerson: PropTypes.func.isRequired,
};

WebOrgRsvPersonalDetailGuide.defaultProps = {
  formValues: undefined,
  frameUsedData: null,
  orglukes: null,
  consultDetail: null,
  message: [],
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  const perFormValues = getFormValues('WebOrgRsvPersonal')(state);
  return {
    initialValues: {
      rsvstatus: perFormValues.rsvstatus,
      prtonsave: perFormValues.prtonsave,
      cardaddrdiv: perFormValues.cardaddrdiv,
      formaddrdiv: perFormValues.formaddrdiv,
      reportaddrdiv: perFormValues.reportaddrdiv,
      issuecslticket: perFormValues.issuecslticket,
      formouteng: perFormValues.formouteng,
      reportouteng: perFormValues.reportouteng,
      cardouteng: perFormValues.cardouteng,
      volunteer: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.volunteer,
      volunteername: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.volunteername,
      collectticket: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.collectticket,
      billprint: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.billprint,
      isrsign: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.isrsign,
      isrno: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.isrno,
      isrmanno: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.isrmanno,
      empno: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.empno,
      zipcd: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.zipcd,
      address1: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.address1,
      address2: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.address2,
      prefname: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.prefname,
      cityname: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.cityname,
      lastcsldate: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.lastcsldate,
      introductor: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.introductor,
      introductname: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.introductname,
    },
    formValues,
    frameUsedData: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData,
    consultDetail: state.app.reserve.webOrgRsv.webOrgRsvList.consultDetail,
    regflg: state.app.reserve.webOrgRsv.webOrgRsvList.regflg,
    orglukes: state.app.reserve.webOrgRsv.webOrgRsvList.orglukes,
    visible: state.app.reserve.webOrgRsv.webOrgRsvPersonalDetailGuide.visible,
    message: state.app.reserve.webOrgRsv.webOrgRsvPersonalDetailGuide.message,
  };
};

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeWebOrgRsvPersonalDetailGuide());
  },
  onPersonalDetailSave: (params) => {
    dispatch(perDetailSave(params));
  },
  onOpenPersonGuide: (onSelected) => {
    dispatch(openPersonGuide({ onSelected }));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(WebOrgRsvPersonalDetailGuideForm));
