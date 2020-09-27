/**
 * @file 個人異常値一覧表
 */
import React from 'react';
import { connect } from 'react-redux';
import { Field, getFormValues, reduxForm } from 'redux-form';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import TextArea from '../../components/control/TextArea';
import SectionBar from '../../components/SectionBar';

// ページタイトル
const TITLE = '依頼状作成';

// フォーム名
const formName = 'FollowReqEditFrom';

// 個人異常値一覧表レイアウト
const FollowReqEdit = () => (
  <div>
    <SectionBar title="依頼内容" />
    <table>
      <tbody>
        <tr>
          <ReportParameter label="診断・依頼項目" >
            <Field name="folitem" component={TextArea} id="folitem" style={{ width: 650, height: 35 }} />
            <Field name="rsvno" component="input" type="hidden" />
            <Field name="upduser" component="input" type="hidden" />
            <Field name="username" component="input" type="hidden" />
            <Field name="judclasscd" component="input" type="hidden" />
            <Field name="judclassname" component="input" type="hidden" />
            <Field name="prtdiv" component="input" type="hidden" />
            <Field name="csldate" component="input" type="hidden" />
            <Field name="perid" component="input" type="hidden" />
            <Field name="age" component="input" type="hidden" />
            <Field name="dayid" component="input" type="hidden" />
            <Field name="name" component="input" type="hidden" />
            <Field name="kname" component="input" type="hidden" />
            <Field name="birth" component="input" type="hidden" />
            <Field name="gender" component="input" type="hidden" />
          </ReportParameter>
        </tr>
        <tr>
          <ReportParameter label="所見" >
            <Field name="folnote" component={TextArea} id="folnote" style={{ marginLeft: '75px', width: 650, height: 200 }} />
          </ReportParameter>
        </tr>
      </tbody>
    </table>
    <SectionBar title="医療機関" />
    <table>
      <tbody>
        <tr>
          <ReportParameter label="病医院名" >
            <Field style={{ width: 450 }} component="input" type="text" name="secequipname" maxLength="50" />
          </ReportParameter>
        </tr>
        <tr>
          <ReportParameter label="診療科" >
            <Field style={{ marginLeft: '15px', width: 450 }} component="input" type="text" name="secequipcourse" maxLength="50" />
          </ReportParameter>
        </tr>
        <tr>
          <ReportParameter label="担当医師" >
            <Field style={{ width: 350 }} component="input" type="text" name="secdoctor" maxLength="40" />
          </ReportParameter>
        </tr>
        <tr>
          <ReportParameter label="住所" >
            <Field style={{ marginLeft: '30px', width: 700 }} component="input" type="text" name="secequipaddr" maxLength="120" />
          </ReportParameter>
        </tr>
        <tr>
          <ReportParameter label="電話番号" >
            <Field style={{ width: 350 }} component="input" type="text" name="secequiptel" maxLength="15" />
          </ReportParameter>
        </tr>
      </tbody>
    </table>
  </div>
);

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      folitem: state.app.followup.follow.followReqEditGuide.folItem,
      folnote: state.app.followup.follow.followReqEditGuide.folNote,
      secequipname: state.app.followup.follow.followReqEditGuide.secEquipName,
      secequipcourse: state.app.followup.follow.followReqEditGuide.secEquipCourse,
      secdoctor: state.app.followup.follow.followReqEditGuide.secDoctor,
      secequipaddr: state.app.followup.follow.followReqEditGuide.secEquipAddr,
      secequiptel: state.app.followup.follow.followReqEditGuide.secEquipTel,
      rsvno: state.app.followup.follow.followReqEditGuide.rsvno,
      upduser: state.app.followup.follow.followReqEditGuide.userid,
      username: state.app.followup.follow.followReqEditGuide.username,
      judclasscd: state.app.followup.follow.followReqEditGuide.judclasscd,
      judclassname: state.app.followup.follow.followReqEditGuide.judClassName,
      prtdiv: state.app.followup.follow.followReqEditGuide.prtdiv,
      csldate: state.app.followup.follow.followReqEditGuide.cslDate,
      perid: state.app.followup.follow.followReqEditGuide.perId,
      age: state.app.followup.follow.followReqEditGuide.realAge,
      dayid: state.app.followup.follow.followReqEditGuide.dayId,
      name: state.app.followup.follow.followReqEditGuide.name,
      kname: state.app.followup.follow.followReqEditGuide.kName,
      birth: state.app.followup.follow.followReqEditGuide.birth,
      gender: state.app.followup.follow.followReqEditGuide.gender,
    },
  };
};

// redux-formでstate管理するようにする
export default connect(mapStateToProps)(reduxForm({
  form: formName,
})(ReportForm(FollowReqEdit, TITLE, 'requestcard')));
