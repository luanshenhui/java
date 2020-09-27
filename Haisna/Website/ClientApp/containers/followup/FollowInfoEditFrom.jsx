import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, getFormValues, reduxForm, blur } from 'redux-form';

import { chkWrite, updateFollowInfoRequest, deleteFollowInfoRequest, updateFollowInfoConfirmRequest, openFollowRslEditGuideRequest } from '../../modules/followup/followModule';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import CheckBox from '../../components/control/CheckBox';
import TextArea from '../../components/control/TextArea';
import Button from '../../components/control/Button';
import SectionBar from '../../components/SectionBar';
import Radio from '../../components/control/Radio';
import Chip from '../../components/Chip';
import FollowInfoEditBody from './FollowInfoEditBody';

const formName = 'FollowInfoEdit';

class FollowInfoEdit extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleSecDateClear = this.handleSecDateClear.bind(this);
    this.handleChkWrite = this.handleChkWrite.bind(this);
    this.handleDeleteClick = this.handleDeleteClick.bind(this);
    this.handleFollowRslConfirm = this.handleFollowRslConfirm.bind(this);
  }

  handleChkWrite(name, value) {
    const { onChkWrite, setValue } = this.props;
    setValue(name, null);
    onChkWrite({ name, value });
  }

  handleSecDateClear() {
    const { setValue } = this.props;
    setValue('secPlanDate', null);
  }

  // 保存ボタンを押下
  handleSubmit(values) {
    const { onSave, rsvNo, judClassCd, conditions } = this.props;
    onSave({ ...values, rsvNo, judClassCd, conditions });
  }

  // 削除ボタンを押下
  handleDeleteClick() {
    const { onDelete, rsvNo, judClassCd, conditions } = this.props;
    onDelete({ rsvNo, judClassCd, conditions });
  }

  // 結果承認又は承認取消ボタンを押下
  handleFollowRslConfirm(reqConfirmFlg, statusCd) {
    const { onFollowRslConfirm, rsvNo, judClassCd, conditions } = this.props;
    onFollowRslConfirm({ reqConfirmFlg, statusCd, rsvNo, judClassCd, conditions });
  }

  render() {
    const { handleSubmit, formValues, rsvNo, judClassCd, onShowFollowRsl, followInfo, judList, followRslList, followRslItemList } = this.props;
    const followInfoEditBody = () => {
      const res = [];
      let key = 0;
      for (let i = 0; i < followRslList.length; i += 1) {
        res.push(<FollowInfoEditBody
          followInfo={followInfo}
          count={i}
          followRslList={followRslList}
          followRslItemList={followRslItemList}
          onShowFollowRsl={onShowFollowRsl}
          key={key}
        />);
        key += 1;
      }
      return res;
    };

    const rsvTestReferText = (rsvTestRefer) => {
      let res;
      if (rsvTestRefer === 1) {
        res = <Field name="rsvTestReferText" component="input" type="text" style={{ width: 80 }} />;
      } else {
        res = <Field name="rsvTestReferText" component="input" type="text" style={{ width: 80, backgroundColor: '#eeeeee' }} readOnly />;
      }
      return res;
    };

    const rsvTestRemark = (rsvTestETC) => {
      let res;
      if (rsvTestETC === 1) {
        res = <Field name="rsvTestRemark" component="input" type="text" style={{ width: 200 }} />;
      } else {
        res = <Field name="rsvTestRemark" component="input" type="text" style={{ width: 200, backgroundColor: '#eeeeee' }} readOnly />;
      }
      return res;
    };

    const judCd = [];
    for (let i = 0; i < judList.length; i += 1) {
      if (i === 0) {
        judCd.push({ value: null, name: null });
      }
      judCd.push({ value: judList[i].judcd, name: judList[i].judcd });
    }

    const radioArray = (secEquipDiv) => {
      const res = [];
      let equipStat = '';
      let checkedValue;
      let key = 0;
      for (let i = 0; i < 5; i += 1) {
        switch (i) {
          case 0:
            equipStat = '二次検査場所未定';
            checkedValue = 0;
            break;
          case 1:
            equipStat = '当センター';
            checkedValue = 1;
            break;
          case 2:
            equipStat = '本院・メディローカス';
            checkedValue = 2;
            break;
          case 3:
            equipStat = '他院';
            checkedValue = 3;
            break;
          case 4:
            equipStat = '対象外';
            checkedValue = 9;
            break;
          default:
            break;
        }
        if (secEquipDiv === checkedValue) {
          res.push(<strong key={`secEquipDiv_${key}`}><Field name="secEquipDiv" component={Radio} checkedValue={checkedValue} label={equipStat} /></strong>);
        } else {
          res.push(<Field key={`secEquipDiv_$_${key}`} name="secEquipDiv" component={Radio} checkedValue={checkedValue} label={equipStat} />);
        }
        key += 1;
      }
      return res;
    };

    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <table>
          <tbody>
            <tr style={{ textAlign: 'center' }}>
              <td style={{ whiteSpace: 'pre', width: 120, backgroundColor: '#cccccc' }}>健診項目</td>
              <td style={{ whiteSpace: 'pre', width: 120, backgroundColor: '#eeeeee' }}><strong>{followInfo && followInfo.judclassname}</strong></td>
              <td style={{ width: 20 }}>&nbsp;</td>
              <td style={{ backgroundColor: '#cccccc', width: 120 }}>判定</td>
              <td style={{ backgroundColor: '#eeeeee', width: 100 }}><Field name="judCd" component={DropDown} items={judCd} id="judCd" /></td>
              <td style={{ whiteSpace: 'pre' }}><strong>&nbsp;最終判定&nbsp;：&nbsp;{followInfo && followInfo.rsljudcd}</strong></td>
              {followInfo && followInfo.reqconfirmdate === null ?
                <td>
                  <Button style={{ marginLeft: '50px' }} onClick={() => this.handleSubmit(formValues)} value="保存" />
                  <Button style={{ marginLeft: '5px' }} onClick={() => this.handleDeleteClick()} value="削除" />
                  <Button style={{ marginLeft: '5px' }} onClick={() => { onShowFollowRsl(rsvNo, judClassCd, 0); }} value="追加" />
                  <Button style={{ marginLeft: '5px' }} onClick={() => this.handleFollowRslConfirm('1', followInfo.statuscd)} value="結果承認" />
                </td>
                :
                <td>
                  <Button style={{ marginLeft: '50px' }} onClick={() => this.handleFollowRslConfirm('0', followInfo.statuscd)} value="承認取消" />
                  <strong style={{ marginLeft: '5px' }}>結果承認済！</strong>
                </td>
              }
            </tr>
          </tbody>
        </table>
        <table style={{ width: '100%' }}>
          <tbody>
            <tr>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;二次検査施設</td>
              <td>
                {radioArray(followInfo.secequipdiv)}
              </td>
            </tr>
            <tr>
              <td style={{ whiteSpace: 'pre', width: 120, backgroundColor: '#cccccc', textAlign: 'left' }}>&nbsp;二次検査予定日</td>
              <td>
                <span><Chip onDelete={this.handleSecDateClear} /></span>
                <Field name="secPlanDate" component={DatePicker} id="secPlanDate" />
              </td>
            </tr>
            <tr>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;二次検査予約項目</td>
              <Field name="rsvTestUS" component={CheckBox} checkedValue={1} label="US" id="checkboxName" />
              <Field name="rsvTestCT" component={CheckBox} checkedValue={1} label="CT" id="checkboxName" />
              <Field name="rsvTestMRI" component={CheckBox} checkedValue={1} label="MRI" id="checkboxName" />
              <Field name="rsvTestBF" component={CheckBox} checkedValue={1} label="BF" id="checkboxName" />
              <Field name="rsvTestGF" component={CheckBox} checkedValue={1} label="GF" id="checkboxName" />
              <Field name="rsvTestCF" component={CheckBox} checkedValue={1} label="CF" id="checkboxName" />
              <Field name="rsvTestEM" component={CheckBox} checkedValue={1} label="注腸" id="checkboxName" />
              <Field name="rsvTestTM" component={CheckBox} checkedValue={1} label="腫瘍マーカー" id="checkboxName" />
              <Field name="rsvTestRefer" component={CheckBox} checkedValue={1} onChange={() => this.handleChkWrite('rsvTestReferText', followInfo.rsvtestrefer)} label="リファー" id="checkboxName" />
              {rsvTestReferText(followInfo.rsvtestrefer)}
              <Field name="rsvTestETC" component={CheckBox} checkedValue={1} onChange={() => this.handleChkWrite('rsvTestRemark', followInfo.rsvtestetc)} label="その他" id="checkboxName" />
              {rsvTestRemark(followInfo.rsvtestetc)}
            </tr>
          </tbody>
        </table>
        <SectionBar title="検査結果" />
        {followInfoEditBody()}
        {followRslList.length === 0 &&
          <table style={{ width: '100%', height: 200, backgroundColor: '#999999' }}>
            <tbody>
              <tr>
                <td style={{ width: '100%', backgroundColor: '#ffffff', textAlign: 'center' }}>
                  二次検査結果データが未登録状態です。<br />
                  【追加】ボタンをクリックして二次検査結果登録ができます。
                </td>
              </tr>
            </tbody>
          </table>
        }
        <table>
          <tbody>
            <tr>
              <td style={{ width: '100%', backgroundColor: '#ffffff' }}>
                <table>
                  <tbody>
                    <tr>
                      <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;ステータス</td>
                      <td>
                        <table>
                          <tbody>
                            <tr>
                              <td style={{ width: 150, whiteSpace: 'pre', backgroundColor: '#eeeeee', textAlign: 'right' }}>診断確定&nbsp;：&nbsp;</td>
                              <td style={{ whiteSpace: 'pre' }}>
                                <Field name="statusCd" component={Radio} checkedValue={11} label="異常なし" />
                                <Field name="statusCd" component={Radio} checkedValue={12} label="異常あり" />
                              </td>
                            </tr>
                            <tr>
                              <td style={{ width: 150, whiteSpace: 'pre', backgroundColor: '#eeeeee', textAlign: 'right' }}>診断未確定(受診施設)&nbsp;：&nbsp;</td>
                              <td style={{ whiteSpace: 'pre' }}>
                                <Field name="statusCd" component={Radio} checkedValue={21} label="センター" />
                                <Field name="statusCd" component={Radio} checkedValue={22} label="本院・メディローカス" />
                                <Field name="statusCd" component={Radio} checkedValue={23} label="他院" />
                                <Field name="statusCd" component={Radio} checkedValue={29} label="その他(未定・不明)" />
                              </td>
                            </tr>
                            <tr>
                              <td style={{ width: 150, whiteSpace: 'pre' }}>&nbsp;</td>
                              <td style={{ whiteSpace: 'pre' }}>
                                <Field name="statusCd" component={Radio} checkedValue={99} label="その他(フォローアップ登録終了)" />
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td style={{ width: 120, backgroundColor: '#cccccc' }}>&nbsp;備考</td>
                      <td colSpan="7">
                        <Field name="secRemark" component={TextArea} id="secRemark" style={{ width: 550, height: 80 }} />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
          </tbody>
        </table>
        <SectionBar title="医療機関" />
        <table>
          <tbody>
            <tr>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;病医院名</td>
              <td><Field style={{ width: 450 }} component="input" type="text" name="secEquipName" maxLength="50" /></td>
            </tr>
            <tr>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;診療科</td>
              <td><Field style={{ width: 450 }} component="input" type="text" name="secEquipCourse" maxLength="50" /></td>
            </tr>
            <tr>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc', width: 120 }}>&nbsp;担当医師</td>
              <td><Field style={{ width: 350 }} component="input" type="text" name="secDoctor" maxLength="40" /></td>
            </tr>
            <tr>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc', width: 120 }}>&nbsp;住所</td>
              <td><Field style={{ width: 700 }} component="input" type="text" name="secEquipAddr" maxLength="120" /></td>
            </tr>
            <tr>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc', width: 120 }}>&nbsp;電話番号</td>
              <td><Field style={{ width: 350 }} component="input" type="text" name="secEquipTel" maxLength="15" /></td>
            </tr>
          </tbody>
        </table>
        <table>
          <tbody>
            <tr>
              <td style={{ width: 120, whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;最初登録日時</td>
              <td style={{ width: 140, whiteSpace: 'pre' }}>{followInfo.adddate && moment(followInfo.adddate).format('M/D/YYYY h:mm:ss A')}</td>
              <td style={{ width: 120, whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;最終更新日時</td>
              <td style={{ width: 140, whiteSpace: 'pre' }}>{followInfo.upddate && moment(followInfo.upddate).format('M/D/YYYY h:mm:ss A')}</td>
              <td style={{ width: 120, whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;結果承認日時</td>
              <td style={{ width: 140, whiteSpace: 'pre' }}>{followInfo.reqconfirmdate && moment(followInfo.reqconfirmdate).format('M/D/YYYY h:mm:ss A')}</td>
            </tr>
            <tr>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;最初登録者</td>
              <td>{followInfo && followInfo.addusername}</td>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;最終更新者</td>
              <td>{followInfo && followInfo.username}</td>
              <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;結果承認者</td>
              <td>{followInfo && followInfo.reqconfirmusername}</td>
            </tr>
          </tbody>
        </table>
      </form>
    );
  }
}

const FollowInfoEditFrom = reduxForm({
  form: formName,
})(FollowInfoEdit);

// propTypesの定義
FollowInfoEdit.propTypes = {
  onSave: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  onFollowRslConfirm: PropTypes.func.isRequired,
  onShowFollowRsl: PropTypes.func.isRequired,
  onChkWrite: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  rsvNo: PropTypes.number.isRequired,
  judClassCd: PropTypes.number.isRequired,
  followInfo: PropTypes.shape().isRequired,
  judList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  followRslList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  followRslItemList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  conditions: PropTypes.shape().isRequired,
  formValues: PropTypes.shape(),
};

FollowInfoEdit.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    followInfo: state.app.followup.follow.followInfoEditGuide.followInfo,
    judList: state.app.followup.follow.followInfoEditGuide.judList,
    followRslList: state.app.followup.follow.followInfoEditGuide.followRslList,
    followRslItemList: state.app.followup.follow.followInfoEditGuide.followRslItemList,
    conditions: state.app.followup.follow.followInfoEditGuide.conditions,
    initialValues: {
      judCd: state.app.followup.follow.followInfoEditGuide.judCd,
      secEquipDiv: state.app.followup.follow.followInfoEditGuide.secEquipDiv,
      secPlanDate: state.app.followup.follow.followInfoEditGuide.secPlanDate,
      rsvTestUS: state.app.followup.follow.followInfoEditGuide.rsvTestUS,
      rsvTestCT: state.app.followup.follow.followInfoEditGuide.rsvTestCT,
      rsvTestMRI: state.app.followup.follow.followInfoEditGuide.rsvTestMRI,
      rsvTestBF: state.app.followup.follow.followInfoEditGuide.rsvTestBF,
      rsvTestGF: state.app.followup.follow.followInfoEditGuide.rsvTestGF,
      rsvTestCF: state.app.followup.follow.followInfoEditGuide.rsvTestCF,
      rsvTestEM: state.app.followup.follow.followInfoEditGuide.rsvTestEM,
      rsvTestTM: state.app.followup.follow.followInfoEditGuide.rsvTestTM,
      rsvTestRefer: state.app.followup.follow.followInfoEditGuide.rsvTestRefer,
      rsvTestReferText: state.app.followup.follow.followInfoEditGuide.rsvTestReferText,
      rsvTestETC: state.app.followup.follow.followInfoEditGuide.rsvTestETC,
      rsvTestRemark: state.app.followup.follow.followInfoEditGuide.rsvTestRemark,
      statusCd: state.app.followup.follow.followInfoEditGuide.statusCd,
      secRemark: state.app.followup.follow.followInfoEditGuide.secRemark,
      secEquipName: state.app.followup.follow.followInfoEditGuide.secEquipName,
      secEquipCourse: state.app.followup.follow.followInfoEditGuide.secEquipCourse,
      secDoctor: state.app.followup.follow.followInfoEditGuide.secDoctor,
      secEquipAddr: state.app.followup.follow.followInfoEditGuide.secEquipAddr,
      secEquipTel: state.app.followup.follow.followInfoEditGuide.secEquipTel,
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  onSave: (params) => {
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('フォローアップ情報を変更します。よろしいですか？')) {
      return;
    }
    // 判定分類別フォローアップ情報保存
    dispatch(updateFollowInfoRequest(params));
  },

  onDelete: (params) => {
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('フォローアップ情報を削除します。\nフォローアップ情報は削除すると元に戻す事が出来ません。\n\n削除してよろしいでしょうか？')) {
      return;
    }
    // 判定分類別フォローアップ情報削除
    dispatch(deleteFollowInfoRequest(params));
  },

  onFollowRslConfirm: (params) => {
    const { reqConfirmFlg, statusCd } = params;
    let confirmMsg;
    if (reqConfirmFlg === '1') {
      if (statusCd === null) {
        // eslint-disable-next-line no-alert,no-restricted-globals
        alert('『ステータス』は必須項目ですので、先に『ステータス』を登録してください。');
        return;
      }
      confirmMsg = '二次検査結果を承認します。                 \n\n承認してよろしいでしょうか？';
    } else {
      confirmMsg = '承認されている二次検査結果を承認取消します。\n\n承認取消してよろしいでしょうか？';
    }
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm(confirmMsg)) {
      return;
    }
    // 判定分類別フォローアップ情報削除
    dispatch(updateFollowInfoConfirmRequest(params));
  },

  onShowFollowRsl: (rsvno, judclasscd, seq) => {
    dispatch(openFollowRslEditGuideRequest({ rsvno, judclasscd, seq }));
  },

  onChkWrite: (rsvTestRefer) => {
    dispatch(chkWrite(rsvTestRefer));
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowInfoEditFrom);
