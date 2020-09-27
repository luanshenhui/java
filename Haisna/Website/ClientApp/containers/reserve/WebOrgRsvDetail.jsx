import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import { Field, getFormValues, reduxForm, blur } from 'redux-form';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import SectionBar from '../../components/SectionBar';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import CheckBox from '../../components/control/CheckBox';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import DropDown from '../../components/control/dropdown/DropDown';
import DatePicker from '../../components/control/datepicker/DatePicker';
import { onChangeCsldivRequset } from '../../modules/reserve/webOrgRsvModule';
import WebOrgRsvOption from './WebOrgRsvOption';
import WebOrgRsvPersonal from './WebOrgRsvPersonal';
import WebOrgRsvReservation from './WebOrgRsvReservation';
import GuideButton from '../../components/GuideButton';
import { openPersonGuide } from '../../modules/preference/personModule';
import PersonGuide from '../../containers/common/PersonGuide';

const formName = 'WebOrgRsvDetail';

const rsvgrpitems = [
  { value: '1', name: '１群（男）-8:00' }, { value: '2', name: '２群（女）-8:20' }, { value: '3', name: '３群（男）-8:40' },
  { value: '4', name: '４群（女）-9:00' }, { value: '5', name: '５群（男）-9:20' }, { value: '6', name: '６群（女）-10:00' },
  { value: '7', name: '７群（男）-10:20' }, { value: '8', name: '８群（女）-10:40' },
];

// 新規受診者用の個人ID欄表示テキスト
const PERID_FOR_NEW_PERSON = '【新規】';

const Wrapper = styled.span`
   font-size: 0.5em;
`;

const WrapperSpan = styled.span`
   color: #ff6600;
`;

class WebOrgRsvDetail extends React.Component {
  constructor(props) {
    super(props);
    this.handleChangeCsldiv = this.handleChangeCsldiv.bind(this);
    this.selectedPerson = this.selectedPerson.bind(this);
  }
  // ドック申し込み個人情報画面呼び出し
  callEditPersonWindow() {
    // TODO
  }
  // 個人選択時の処理
  selectedPerson(data) {
    const { onChangeCsldiv, formValues, optionFormValues, frameUsedData, consultData } = this.props;

    onChangeCsldiv({ optionFormValues, frameUsedData, consultData, data: { ...data, csldivcd: formValues.csldivcd } });

    frameUsedData.perid = data.perid;
    frameUsedData.lastkname = data.lastkname;
    frameUsedData.firstkname = data.firstkname;
    frameUsedData.lastname = data.lastname;
    frameUsedData.firstkname = data.firstkname;
    frameUsedData.age = Math.floor(Number(data.age));
    frameUsedData.birth = data.birth;
    frameUsedData.medbirthyearshorteraname = data.medbirthyearshorteraname;
    frameUsedData.medbirtherayear = data.medbirtherayear;
    frameUsedData.gender = data.gender;
  }
  // 表示
  handleChangeCsldiv(event) {
    const { formValues, onChangeCsldiv, optionFormValues, frameUsedData, consultData } = this.props;
    const data = {};
    data.perid = formValues.perid;
    data.gender = formValues.gender;
    data.birth = formValues.birth;
    if (event.target.value !== '' && event.target.value !== undefined && event.target.value !== null) {
      data.csldivcd = event.target.value;
    }
    onChangeCsldiv({ data, optionFormValues, frameUsedData, consultData });
  }
  render() {
    const { frameUsedData, age, onOpenPersonGuide, formValues, webOrgRsvData, consultData, csldivitems, ctrptoptfromconsult } = this.props;
    return (
      <div>
        <form>
          <div style={{ float: 'left', overflow: 'auto' }}>
            <FieldGroup itemWidth={100}>
              <div>
                <SectionBar title="基本情報" />
              </div>
              <FieldSet>
                {consultData && consultData.cancelflg !== null && consultData.cancelflg !== 0 && (
                  <div>
                    <WrapperSpan>
                      この受診情報はキャンセルされています。
                    </WrapperSpan> &nbsp;&nbsp; キャンセル理由：
                    <WrapperSpan>{frameUsedData.reason}</WrapperSpan>
                  </div>
                )}
              </FieldSet>
              <FieldSet>
                <FieldItem>個人名</FieldItem>
                {frameUsedData && frameUsedData.regflg !== '2' && (
                  <GuideButton
                    onClick={() => { onOpenPersonGuide(this.selectedPerson); }}
                  />
                )}
                <PersonGuide />
                <Label>{formValues && formValues !== null && formValues.perid !== null ? formValues.perid : PERID_FOR_NEW_PERSON }</Label>
                <div style={{ marginTop: '-25px' }} >
                  <div>
                    <Wrapper>{formValues && formValues.lastkname}{formValues && formValues.firstkname}</Wrapper>
                  </div>
                  <div style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>
                    <a role="presentation" onClick={() => (this.callEditPersonWindow())} >
                      {formValues && formValues.lastname}{formValues && formValues.firstname}
                    </a>
                  </div>
                </div>
                <div style={{ marginTop: '27px', marginLeft: '-136px' }}>
                  <Label>{formValues && formValues.birthyearshorteraname}{formValues && formValues.birtherayear} {moment(formValues && formValues.birth).format('MM.DD')}生 </Label>
                  <Label>{Math.floor(Number(formValues && formValues.age))}歳 </Label>
                  {formValues && formValues.gender === 2 ? '女性' : '男性'}
                </div>
              </FieldSet>
              <FieldSet>
                <FieldItem>団体</FieldItem>
                <Label >
                  {formValues && formValues.orgname}
                </Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>コース</FieldItem>
                <Field name="cscd" component={DropDownCourse} addblank blankname="" isdisabled="disabled" />
                <FieldItem>受診区分</FieldItem>
                {ctrptoptfromconsult && ctrptoptfromconsult.length > 0 &&
                  <Field name="csldivcd" component={DropDown} items={csldivitems} blankname="" onChange={this.handleChangeCsldiv} isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''} />
                }
                {ctrptoptfromconsult && ctrptoptfromconsult.length === 0 &&
                  <Field
                    name="csldivcd"
                    component={DropDown}
                    items={csldivitems}
                    addblank
                    blankname=""
                    onChange={this.handleChangeCsldiv}
                    isdisabled={frameUsedData.regflg === '2' ? 'disabled' : ''}
                  />
                }
              </FieldSet>
              <FieldSet>
                <FieldItem>受診日時</FieldItem>
                <Field name="csldate" component={DatePicker} disabled="disabled" />&nbsp;&nbsp;
                <Field name="rsvgrpcd" component={DropDown} items={rsvgrpitems} isdisabled="disabled" />
                {frameUsedData.regflg !== '2' &&
                  <div>
                    <Field component={CheckBox} name="ignoreflg" checkedValue={1} />強制登録を行う
                  </div>
                }
              </FieldSet>
            </FieldGroup>
          </div>
        </form>
        <div style={{ float: 'left', overflow: 'auto', width: '478px' }}>
          <WebOrgRsvPersonal />
        </div>
        <div style={{ float: 'left', overflow: 'auto' }}>
          <WebOrgRsvOption />
        </div>
        <div style={{ float: 'left', overflow: 'auto' }}>
          <WebOrgRsvReservation webOrgRsvData={webOrgRsvData} age={age} />
        </div>
      </div>);
  }
}


const WebOrgRsvDetailForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(WebOrgRsvDetail);

// propTypesの定義
WebOrgRsvDetail.propTypes = {
  age: PropTypes.number,
  onChangeCsldiv: PropTypes.func.isRequired,
  onOpenPersonGuide: PropTypes.func.isRequired,
  frameUsedData: PropTypes.shape().isRequired,
  consultData: PropTypes.shape(),
  optionFormValues: PropTypes.shape(),
  formValues: PropTypes.shape(),
  webOrgRsvData: PropTypes.shape(),
  csldivitems: PropTypes.arrayOf(PropTypes.shape()),
  ctrptoptfromconsult: PropTypes.arrayOf(PropTypes.shape()),
};

WebOrgRsvDetail.defaultProps = {
  consultData: null,
  age: null,
  optionFormValues: null,
  formValues: undefined,
  webOrgRsvData: null,
  csldivitems: [],
  ctrptoptfromconsult: [],
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  const optionFormValues = getFormValues('webOrgRsvOption')(state);
  return {
    formValues,
    optionFormValues,
    initialValues: {
      cscd: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.cscd,
      csldivcd: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.csldivcd,
      rsvgrpcd: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.rsvgrpcd,
      csldate: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.csldate,
      age: state.app.reserve.webOrgRsv.webOrgRsvOptionList.realage,
      orgcd1: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.orgcd1,
      orgcd2: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.orgcd2,
      orgname: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.orgname,
      perid: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.perid,
      lastkname: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.lastkname,
      firstkname: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.firstkname,
      lastname: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.lastname,
      firstname: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.firstname,
      birtherayear: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.birtherayear,
      birth: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.birth,
      birthyearshorteraname: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.birthyearshorteraname,
      gender: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData.gender,
    },
    csldate: state.app.reserve.webOrgRsv.webOrgRsvList.csldate,
    frameUsedData: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData,
    regflg: state.app.reserve.webOrgRsv.webOrgRsvList.regflg,
    age: state.app.reserve.webOrgRsv.webOrgRsvOptionList.realage,
    selectedItem: state.app.preference.organization.organizationGuide.selectedItem,
    webOrgRsvData: state.app.reserve.webOrgRsv.webOrgRsvList.webOrgRsvData,
    consultData: state.app.reserve.webOrgRsv.webOrgRsvList.consultData,
    csldivitems: state.app.reserve.webOrgRsv.webOrgRsvList.csldivitems,
    ctrptoptfromconsult: state.app.reserve.webOrgRsv.webOrgRsvOptionList.ctrptoptfromconsult,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onChangeCsldiv: ({ data, optionFormValues, frameUsedData, consultData }) => {
    const params = {};
    params.perid = data.perid;
    params.gender = data.gender;
    params.birth = data.birth;
    params.orgcd1 = frameUsedData.orgcd1;
    params.orgcd2 = frameUsedData.orgcd2;
    params.cscd = frameUsedData.cscd;
    params.csldate = frameUsedData.csldate;
    if (data.csldivcd !== '' && data.csldivcd !== undefined && data.csldivcd !== null) {
      params.csldivcd = data.csldivcd;
    }
    params.stomac = frameUsedData.optionstomac;
    params.breast = frameUsedData.optionbreast;
    params.csloptions = frameUsedData.csloptions;
    // 検査セット画面に全セット表示フラグのエレメントが存在する場合
    params.showall = null;
    if (optionFormValues && optionFormValues.showall !== null) {
      params.showall = optionFormValues.showall;
    }

    // 契約パターンコード指定時
    params.ctrptcd = '';
    if (consultData && consultData.ctrptcd !== null) {
      params.ctrptcd = consultData.ctrptcd;
    }

    // オプションコード指定時
    params.optcd = '';
    params.optbranchno = '';
    dispatch(onChangeCsldivRequset({ params, frameUsedData }));
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

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(WebOrgRsvDetailForm));
