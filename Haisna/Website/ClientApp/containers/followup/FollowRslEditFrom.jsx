import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { Field, getFormValues, reduxForm, blur } from 'redux-form';

import { chkWrite, shortStcHandle, updateFollowRslRequest, deleteFollowRslRequest } from '../../modules/followup/followModule';
import DatePicker from '../../components/control/datepicker/DatePicker';
import CheckBox from '../../components/control/CheckBox';
import TextArea from '../../components/control/TextArea';
import Button from '../../components/control/Button';
import SectionBar from '../../components/SectionBar';
import Radio from '../../components/control/Radio';
import Chip from '../../components/Chip';
import FollowRslEditBody from './FollowRslEditBody';


const formName = 'FollowRslEdit';

const Font = styled.span`
  color: Red;
`;

class FollowRslEdit extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleSecCslDateClear = this.handleSecCslDateClear.bind(this);
    this.handleChkWrite = this.handleChkWrite.bind(this);
    this.handleDeleteClick = this.handleDeleteClick.bind(this);
  }

  handleChkWrite(name, value) {
    const { onChkWrite, setValue } = this.props;
    setValue(name, null);
    onChkWrite({ name, value });
  }

  handleSecCslDateClear() {
    const { setValue } = this.props;
    setValue('secCslDate', null);
  }

  // 保存ボタンを押下
  handleSubmit(values) {
    const { onSave, rsvno, judclasscd, seq, followRslItemList } = this.props;
    onSave({ ...values, rsvno, judclasscd, seq, followRslItemList });
  }

  // 削除ボタンを押下
  handleDeleteClick() {
    const { onDelete, rsvno, judclasscd, seq } = this.props;
    onDelete({ rsvno, judclasscd, seq });
  }

  render() {
    const { handleSubmit, onShortStcClear, onShortStcSet, followInfo, followRsl, followRslItemList, formValues } = this.props;

    const secEquipDivName = (secEquipDiv) => {
      let strSecEquipDivName = '';
      switch (secEquipDiv) {
        case 0:
          strSecEquipDivName = '二次検査場所未定';
          break;
        case 1:
          strSecEquipDivName = '当センター';
          break;
        case 2:
          strSecEquipDivName = '本院・メディローカス';
          break;
        case 3:
          strSecEquipDivName = '他院';
          break;
        default:
          break;
      }
      return strSecEquipDivName;
    };

    const testReferText = (testRefer) => {
      let res;
      if (testRefer === 1) {
        res = <Field name="testReferText" component="input" type="text" style={{ width: 80 }} maxLength="40" />;
      } else {
        res = <Field name="testReferText" component="input" type="text" style={{ width: 80, backgroundColor: '#eeeeee' }} maxLength="40" readOnly />;
      }
      return res;
    };

    const testRemark = (testETC) => {
      let res;
      if (testETC === 1) {
        res = <Field style={{ width: 200 }} component="input" type="text" name="testRemark" maxLength="40" />;
      } else {
        res = <Field style={{ width: 200, backgroundColor: '#eeeeee' }} component="input" type="text" name="testRemark" maxLength="45" readOnly />;
      }
      return res;
    };

    const polMonth = (polFollowup) => {
      let res;
      if (polFollowup === 1) {
        res = <Field style={{ width: 30 }} component="input" type="text" name="polMonth" maxLength="3" />;
      } else {
        res = <Field style={{ width: 30, backgroundColor: '#eeeeee' }} component="input" type="text" name="polMonth" maxLength="3" readOnly />;
      }
      return res;
    };

    const polRemark1 = (polETC1) => {
      let res;
      if (polETC1 === 1) {
        res = <Field style={{ width: 240 }} component="input" type="text" name="polRemark1" maxLength="50" />;
      } else {
        res = <Field style={{ width: 240, backgroundColor: '#eeeeee' }} component="input" type="text" name="polRemark1" maxLength="50" readOnly />;
      }
      return res;
    };

    const polRemark2 = (polETC2) => {
      let res;
      if (polETC2 === 1) {
        res = <Field style={{ width: 240 }} component="input" type="text" name="polRemark2" maxLength="50" />;
      } else {
        res = <Field style={{ width: 240, backgroundColor: '#eeeeee' }} component="input" type="text" name="polRemark2" maxLength="50" readOnly />;
      }
      return res;
    };

    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <table>
          <tbody>
            <tr style={{ textAlign: 'left' }}>
              <td style={{ whiteSpace: 'pre', width: 120, backgroundColor: '#cccccc' }}>&nbsp;健診項目</td>
              <td style={{ whiteSpace: 'pre', width: 120, backgroundColor: '#eeeeee' }}><strong>&nbsp;{followInfo && followInfo.judclassname}</strong></td>
              <td style={{ backgroundColor: '#cccccc', width: 120 }}>&nbsp;判定</td>
              <td style={{ backgroundColor: '#eeeeee', width: 160 }}>
                <strong>&nbsp;{followInfo && followInfo.judcd}&nbsp;(&nbsp;最終判定&nbsp;：&nbsp;{followInfo && followInfo.rsljudcd}&nbsp;)</strong>
              </td>
            </tr>
            <tr style={{ textAlign: 'left' }}>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc', width: 120 }}>&nbsp;二次検査施設</td>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#eeeeee', width: 160 }}>
                <strong>&nbsp;{secEquipDivName(followInfo.secequipdiv)}</strong>
              </td>
              <td style={{ whiteSpace: 'pre', width: 120, backgroundColor: '#cccccc' }}>&nbsp;二次検査予定日</td>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#eeeeee', width: 160 }}>
                <strong>&nbsp;{followInfo.secplandate && moment(followInfo.secplandate).format('M/D/YYYY')}</strong>
              </td>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc', width: 120 }}>&nbsp;二次検査予定項目</td>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#eeeeee', width: 180 }}><strong>&nbsp;{followInfo.rsvtestname}</strong></td>
            </tr>
          </tbody>
        </table>
        <SectionBar title="検査結果" />
        <table>
          <tbody>
            <tr>
              <td style={{ width: '100%' }}>
                <table>
                  <tbody>
                    <tr>
                      <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc', width: 120 }}>&nbsp;検査（治療）実施日&nbsp;</td>
                      <td>
                        <table>
                          <tbody>
                            <tr>
                              <td>
                                <span><Chip onDelete={this.handleSecCslDateClear} /></span>
                                <Field name="secCslDate" component={DatePicker} id="secCslDate" />
                              </td>
                              <td><Font>&nbsp;※必須項目</Font></td>
                              <td>
                                <Button style={{ marginLeft: '100px' }} onClick={() => this.handleSubmit(formValues)} value="保存" />
                                {followRsl.upduser &&
                                  <Button style={{ marginLeft: '5px' }} onClick={() => this.handleDeleteClick()} value="削除" />
                                }
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;二次検査項目</td>
                      <Field name="testUS" component={CheckBox} checkedValue={1} label="US  " id="checkboxName" />
                      <Field name="testCT" component={CheckBox} checkedValue={1} label="CT  " id="checkboxName" />
                      <Field name="testMRI" component={CheckBox} checkedValue={1} label="MRI  " id="checkboxName" />
                      <Field name="testBF" component={CheckBox} checkedValue={1} label="BF  " id="checkboxName" />
                      <Field name="testGF" component={CheckBox} checkedValue={1} label="GF  " id="checkboxName" />
                      <Field name="testCF" component={CheckBox} checkedValue={1} label="CF  " id="checkboxName" />
                      <Field name="testEM" component={CheckBox} checkedValue={1} label="注腸  " id="checkboxName" />
                      <Field name="testTM" component={CheckBox} checkedValue={1} label="腫瘍マーカー " id="checkboxName" />
                      <Field
                        name="testRefer"
                        component={CheckBox}
                        checkedValue={1}
                        onChange={() => this.handleChkWrite('testReferText', followRsl.testrefer)}
                        label="リファー"
                        id="checkboxName"
                      />
                      {testReferText(followRsl.testrefer)}
                      <Field name="testETC" component={CheckBox} checkedValue={1} onChange={() => this.handleChkWrite('testRemark', followRsl.testetc)} label="その他" id="checkboxName" />
                      {testRemark(followRsl.testetc)}
                    </tr>
                    <tr>
                      <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc', width: 120 }}>&nbsp;二次検査結果</td>
                      <td>
                        <Field name="resultDiv" component={Radio} checkedValue={1} label="異常なし  " />
                        <Field name="resultDiv" component={Radio} checkedValue={2} label="不明  " />
                        <Field name="resultDiv" component={Radio} checkedValue={3} label="診断名あり：下記の診断名より選択" />
                      </td>
                    </tr>
                    <tr>
                      <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc', width: 120 }}>&nbsp;診断名</td>
                      <td>
                        <FollowRslEditBody followRslItemList={followRslItemList} onShortStcClear={onShortStcClear} onShortStcSet={onShortStcSet} />
                      </td>
                    </tr>
                    <tr>
                      <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;その他疾患</td>
                      <td colSpan="7">
                        <Field name="disRemark" component={TextArea} id="disRemark" style={{ width: 550, height: 80 }} />
                      </td>
                    </tr>
                    <tr>
                      <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;方針（治療なし）</td>
                      <Field name="polWithout" component={CheckBox} checkedValue={1} label="処置不要  " id="checkboxName" />
                      <Field name="polFollowup" component={CheckBox} checkedValue={1} onChange={() => this.handleChkWrite('polMonth', followRsl.polfollowup)} label="経過観察 (" id="checkboxName" />
                      {polMonth(followRsl.polfollowup)} )ヶ月&nbsp;
                      <Field name="polReExam" component={CheckBox} checkedValue={1} label="1年後健診  " id="checkboxName" />
                      <Field name="polDiagSt" component={CheckBox} checkedValue={1} label="本院・メディローカス紹介（精査）  " id="checkboxName" />
                      <Field name="polDiag" component={CheckBox} checkedValue={1} label="他院紹介（精査）  " id="checkboxName" />
                      <Field name="polETC1" component={CheckBox} checkedValue={1} onChange={() => this.handleChkWrite('polRemark1', followRsl.poletc1)} label="その他" id="checkboxName" />
                      {polRemark1(followRsl.poletc1)}
                    </tr>
                    <tr>
                      <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;方針（治療あり）</td>
                      <Field name="polSugery" component={CheckBox} checkedValue={1} label="外科治療  " id="checkboxName" />
                      <Field name="polEndoscope" component={CheckBox} checkedValue={1} label="内視鏡的治療  " id="checkboxName" />
                      <Field name="polChemical" component={CheckBox} checkedValue={1} label="化学療法  " id="checkboxName" />
                      <Field name="polRadiation" component={CheckBox} checkedValue={1} label="放射線治療  " id="checkboxName" />
                      <Field name="polReferSt" component={CheckBox} checkedValue={1} label="本院・メディローカス紹介  " id="checkboxName" />
                      <Field name="polRefer" component={CheckBox} checkedValue={1} label="他院紹介  " id="checkboxName" />
                      <Field name="polETC2" component={CheckBox} checkedValue={1} onChange={() => this.handleChkWrite('polRemark2', followRsl.poletc2)} label="その他" id="checkboxName" />
                      {polRemark2(followRsl.poletc2)}
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
          </tbody>
        </table>
      </form>
    );
  }
}

const FollowRslEditFrom = reduxForm({
  form: formName,
})(FollowRslEdit);

// propTypesの定義
FollowRslEdit.propTypes = {
  followInfo: PropTypes.shape().isRequired,
  followRsl: PropTypes.shape().isRequired,
  followRslItemList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onSave: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  onChkWrite: PropTypes.func.isRequired,
  onShortStcClear: PropTypes.func.isRequired,
  onShortStcSet: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  rsvno: PropTypes.number.isRequired,
  judclasscd: PropTypes.number.isRequired,
  seq: PropTypes.number.isRequired,
  formValues: PropTypes.shape(),
};

FollowRslEdit.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    followInfo: state.app.followup.follow.followRslEditGuide.followInfo,
    followRsl: state.app.followup.follow.followRslEditGuide.followRsl,
    followRslItemList: state.app.followup.follow.followRslEditGuide.followRslItemList,
    initialValues: {
      secCslDate: state.app.followup.follow.followRslEditGuide.secCslDate,
      testUS: state.app.followup.follow.followRslEditGuide.testUS,
      testCT: state.app.followup.follow.followRslEditGuide.testCT,
      testMRI: state.app.followup.follow.followRslEditGuide.testMRI,
      testBF: state.app.followup.follow.followRslEditGuide.testBF,
      testGF: state.app.followup.follow.followRslEditGuide.testGF,
      testCF: state.app.followup.follow.followRslEditGuide.testCF,
      testEM: state.app.followup.follow.followRslEditGuide.testEM,
      testTM: state.app.followup.follow.followRslEditGuide.testTM,
      testRefer: state.app.followup.follow.followRslEditGuide.testRefer,
      testReferText: state.app.followup.follow.followRslEditGuide.testReferText,
      testETC: state.app.followup.follow.followRslEditGuide.testETC,
      testRemark: state.app.followup.follow.followRslEditGuide.testRemark,
      resultDiv: state.app.followup.follow.followRslEditGuide.resultDiv,
      disRemark: state.app.followup.follow.followRslEditGuide.disRemark,
      polWithout: state.app.followup.follow.followRslEditGuide.polWithout,
      polFollowup: state.app.followup.follow.followRslEditGuide.polFollowup,
      polMonth: state.app.followup.follow.followRslEditGuide.polMonth,
      polReExam: state.app.followup.follow.followRslEditGuide.polReExam,
      polDiagSt: state.app.followup.follow.followRslEditGuide.polDiagSt,
      polDiag: state.app.followup.follow.followRslEditGuide.polDiag,
      polETC1: state.app.followup.follow.followRslEditGuide.polETC1,
      polRemark1: state.app.followup.follow.followRslEditGuide.polRemark1,
      polSugery: state.app.followup.follow.followRslEditGuide.polSugery,
      polEndoscope: state.app.followup.follow.followRslEditGuide.polEndoscope,
      polChemical: state.app.followup.follow.followRslEditGuide.polChemical,
      polRadiation: state.app.followup.follow.followRslEditGuide.polRadiation,
      polReferSt: state.app.followup.follow.followRslEditGuide.polReferSt,
      polRefer: state.app.followup.follow.followRslEditGuide.polRefer,
      polETC2: state.app.followup.follow.followRslEditGuide.polETC2,
      polRemark2: state.app.followup.follow.followRslEditGuide.polRemark2,
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  onSave: (values) => {
    const { secCslDate, followRslItemList } = values;
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('フォローアップ情報を変更します。よろしいですか？')) {
      return;
    }
    if (secCslDate === null) {
      // eslint-disable-next-line no-alert,no-restricted-globals
      alert('『二次検査実施日』は必須項目ですので正しく入力してください。');
      return;
    }
    const itemCd = [];
    const suffix = [];
    const result = [];
    for (let i = 0; i < followRslItemList.length; i += 1) {
      itemCd.push(followRslItemList[i].itemcd);
      suffix.push(followRslItemList[i].suffix);
      result.push(followRslItemList[i].result);
    }
    const params = { ...values, itemCd, suffix, result };
    // 判定分類別フォローアップ情報保存
    dispatch(updateFollowRslRequest(params));
  },

  onDelete: (params) => {
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('フォローアップ情報を削除します。よろしいですか？')) {
      return;
    }
    // 判定分類別フォローアップ情報削除
    dispatch(deleteFollowRslRequest(params));
  },

  onChkWrite: (rsvTestRefer) => {
    dispatch(chkWrite(rsvTestRefer));
  },

  // 結果疾患（文章）のクリア
  onShortStcClear: (index) => {
    dispatch(shortStcHandle({ index }));
  },

  // 結果疾患（文章）の編集
  onShortStcSet: (value) => {
    dispatch(shortStcHandle(value));
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowRslEditFrom);
