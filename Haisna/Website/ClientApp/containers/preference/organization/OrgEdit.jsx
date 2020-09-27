import React from 'react';
import PropTypes from 'prop-types';
import { Field, FieldArray, getFormValues, reduxForm, blur, formValueSelector } from 'redux-form';
import { connect } from 'react-redux';

import PageLayout from '../../../layouts/PageLayout';
import MessageBanner from '../../../components/MessageBanner';
import { initializeOrg, getOrgRequest, registerOrgRequest, deleteOrgRequest, openOrgRptSetOptionGuide } from '../../../modules/preference/organizationModule';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import DropDown from '../../../components/control/dropdown/DropDown';
import CheckBox from '../../../components/control/CheckBox';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../../components/Field';
import Label from '../../../components/control/Label';
import Radio from '../../../components/control/Radio';
import DropDownFreeValue from '../../../components/control/dropdown/DropDownFreeValue';
import OrgAddresses from './OrgAddresses';
import ZipGuide from '../../common/ZipGuide';
import TextArea from '../../../components/control/TextArea';
import TextBox from '../../../components/control/TextBox';
import Button from '../../../components/control/Button';
import { openZipGuide, getZipListRequest } from '../../../modules/preference/zipModule';
import { openCommentListFlameGuide } from '../../../modules/preference/pubNoteModule';
import RptSetOptionGuide from './RptSetOptionGuide';
import CommentListFlameGuide from '../../preference/comment/CommentListFlameGuide';

// 使用状態選択肢
const delflgItems = [{ value: 0, name: '使用中①' }, { value: 2, name: '使用中②' }, { value: 3, name: '長期未使用' }, { value: 1, name: '未使用' }];

// 口座種別選択肢
const accountkindItems = [{ value: 1, name: '普通' }, { value: 2, name: '当座' }];

// 定期訪問予定日選択肢
const visitdateItems = [...Array(31)].map((v, i) => ({ value: i + 1, name: (i + 1).toString() }));

// 年始・中元・歳暮選択肢
const presentsItems = [{ value: 1, name: '出力する' }, { value: 0, name: '出力しない' }];

// DM選択肢
const directmailItems = [{ value: 1, name: '住所１' }, { value: 2, name: '住所２' }, { value: 3, name: '住所３' }, { value: 0, name: '出力しない' }];

// 送信方法選択肢
const sendmethodItems = [{ value: 0, name: '個別' }, { value: 1, name: '一括' }];

// 利用権区分選択肢
const ticketdivItems = [{ value: 1, name: '貴社専用フォーム' }, { value: 2, name: '健保組合フォーム' }, { value: 3, name: '健保連フォーム' }, { value: 4, name: '聖路加フォーム' }];

// 適用住所
const billaddressItems = [{ value: 1, name: '住所１' }, { value: 2, name: '住所２' }, { value: 3, name: '住所３' }];

const formName = 'orgEdit';

class OrgEdit extends React.Component {
  constructor(props) {
    super(props);

    const { match } = this.props;
    this.orgcd1 = match.params.orgcd1;
    this.orgcd2 = match.params.orgcd2;

    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.handleSelectedZipGuide = this.handleSelectedZipGuide.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentWillMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { history } = this.props;
    history.push('/contents/preference/organization');
  }

  // 削除
  handleRemoveClick() {
    const { onDelete, match, history } = this.props;

    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この団体情報を削除します。よろしいですか？')) {
      return;
    }

    onDelete(match.params, () => history.replace('/contents/preference/organization/edit'));
  }

  // 郵便番号ガイドの行選択時イベント
  handleSelectedZipGuide(item) {
    const { setValue, targets } = this.props;
    // 郵便番号をセット
    setValue(targets.zipcd, `${item.zipcd1}${item.zipcd2}`);
    // 都道府県コードをセット
    setValue(targets.prefcd, item.prefcd);
    // 市区町村
    setValue(targets.cityname, item.cityname);
    // 住所１
    setValue(targets.address1, item.section);
  }

  // 登録
  handleSubmit(values) {
    const { history, match, onSubmit } = this.props;
    const { orgcd1, orgcd2 } = values.org;

    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('団体情報を変更します。よろしいですか？')) {
      return;
    }

    onSubmit(match.params, values, () => history.replace(`/contents/preference/organization/edit/${orgcd1}/${orgcd2}`));
  }

  // 契約参照ボタンクリック時の処理
  handleCtrCourseClick() {
    const { history, match } = this.props;
    history.push(`/contents/preference/contract/organization/${match.params.orgcd1}/${match.params.orgcd2}/courses`);
  }

  // コメントボタンクリック時の処理
  handleShowGuideNoteClick(values) {
    const { onShowGuideNote } = this.props;
    const { orgcd1, orgcd2 } = values.org;
    const params = {};
    params.orgcd1 = orgcd1;
    params.orgcd2 = orgcd2;
    params.dispmode = '5';
    params.cmtmode = '0,0,1,0';
    params.perid = null;
    params.rsvno = null;
    params.ctrptcd = null;
    params.userid = 'HAINS$';
    params.startdate = null;
    params.enddate = null;
    params.act = null;
    onShowGuideNote(params);
  }

  render() {
    const { formValues, handleSubmit, message, messageType, onOpenZipGuide, onOpenOrgRptSetOptionGuide, orgRptSetOptionGuideConditions, match } = this.props;
    const isLoaded = this.orgcd1 !== undefined && this.orgcd2 !== undefined;

    return (
      <PageLayout title="団体情報メンテナンス">
        <div>
          <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
            <div>
              <Button onClick={this.handleCancelClick} value="戻る" />
              {isLoaded && <Button onClick={this.handleRemoveClick} value="削除" />}
              {isLoaded && <Button onClick={() => this.handleCtrCourseClick()} value="契約参照" />}
              {isLoaded && <Button onClick={handleSubmit((values) => this.handleShowGuideNoteClick(values))} value="コメント" />}
              <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
            </div>
            <MessageBanner messages={message} mode="alert" type={messageType} />
            <FieldGroup itemWidth={200}>
              <FieldSet>
                <FieldItem>団体コード</FieldItem>
                {isLoaded && <Label>{this.orgcd1}-{this.orgcd1}</Label>}
                {!isLoaded && <Field name="org.orgcd1" component={TextBox} disabled={isLoaded} id="orgcd1" style={{ width: 70 }} maxLength="5" />}
                {!isLoaded && <Label>-</Label>}
                {!isLoaded && <Field name="org.orgcd2" component={TextBox} disabled={isLoaded} id="orgcd2" style={{ width: 70 }} maxLength="5" />}
              </FieldSet>
              <FieldSet>
                <FieldItem>使用状態</FieldItem>
                <Field name="org.delflg" component={DropDown} items={delflgItems} id="delflg" selectedValue="3" />
              </FieldSet>
              <FieldSet>
                <FieldItem>団体カナ名称</FieldItem>
                <Field name="org.orgkname" component={TextBox} id="orgkname" style={{ width: 390 }} maxLength="40" />
              </FieldSet>
              <FieldSet>
                <FieldItem>団体名称</FieldItem>
                <Field name="org.orgname" component={TextBox} id="orgname" style={{ width: 390 }} maxLength="50" />
              </FieldSet>
              <FieldSet>
                <FieldItem>団体名称（英語）</FieldItem>
                <Field name="org.orgename" component={TextBox} id="orgename" style={{ width: 390 }} maxLength="50" />
              </FieldSet>
              <FieldSet>
                <FieldItem>団体略称</FieldItem>
                <Field name="org.orgsname" component={TextBox} id="orgsname" style={{ width: 390 }} maxLength="20" />
              </FieldSet>
              <FieldSet>
                <FieldItem>団体種別</FieldItem>
                <Field name="org.orgdivcd" component={DropDownFreeValue} freecd="ORGDIV" addblank id="orgdivcd" />
              </FieldSet>
              <FieldSet>
                <FieldItem>請求書用名称</FieldItem>
                <Field name="org.orgbillname" component={TextBox} id="orgbillname" style={{ width: 390 }} maxLength="60" />
              </FieldSet>
            </FieldGroup>
            <FieldArray name="orgaddr" component={OrgAddresses} onOpenZipGuide={onOpenZipGuide} formName={formName} />
            <FieldGroup itemWidth={200}>
              <FieldSet>
                <FieldItem>銀行名</FieldItem>
                <Field name="org.bank" component={TextBox} id="bank" maxLength="10" />
              </FieldSet>
              <FieldSet>
                <FieldItem>支店名</FieldItem>
                <Field name="org.branch" component={TextBox} id="branch" maxLength="10" />
              </FieldSet>
              <FieldSet>
                <FieldItem>口座</FieldItem>
                <Label>種別：</Label>
                <Field name="org.accountkind" component={DropDown} items={accountkindItems} addblank id="accountkind" />
                <Label>番号：</Label>
                <Field name="org.accountno" component={TextBox} maxLength="10" />
              </FieldSet>
              <FieldSet>
                <FieldItem>社員数</FieldItem>
                <Field name="org.numemp" component={TextBox} id="numemp" maxLength="6" style={{ width: 80 }} />
              </FieldSet>
              <FieldSet>
                <FieldItem>平均年齢</FieldItem>
                <Field name="org.avgage" component={TextBox} id="avgage" maxLength="3" style={{ width: 80 }} />
              </FieldSet>
              <FieldSet>
                <FieldItem>定期訪問予定日</FieldItem>
                <Label>毎月</Label>
                <Field name="org.visitdate" component={DropDown} items={visitdateItems} addblank id="visitdate" />
                <Label>日</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>年始・中元・歳暮</FieldItem>
                <Field name="org.presents" component={DropDown} items={presentsItems} addblank id="presents" />
              </FieldSet>
              <FieldSet>
                <FieldItem>DM</FieldItem>
                <Field name="org.directmail" component={DropDown} items={directmailItems} addblank id="directmail" />
              </FieldSet>
              <FieldSet>
                <FieldItem>送付方法</FieldItem>
                <Field name="org.sendmethod" component={DropDown} items={sendmethodItems} addblank id="sendmethod" />
              </FieldSet>
              <FieldSet>
                <FieldItem>確認はがき</FieldItem>
                <Field component={Radio} name="org.postcard" checkedValue={1} label="有" />
                <Field component={Radio} name="org.postcard" checkedValue={0} label="無" />
              </FieldSet>
              <FieldSet>
                <FieldItem>一括送付案内</FieldItem>
                <Field component={Radio} name="org.packagesend" checkedValue={1} label="有" />
                <Field component={Radio} name="org.packagesend" checkedValue={0} label="無" />
              </FieldSet>
              <FieldSet>
                <FieldItem>利用券</FieldItem>
                <Field component={Radio} name="org.ticket" checkedValue={1} label="利用する" />
                <Field component={Radio} name="org.ticket" checkedValue={0} label="利用しない" />
              </FieldSet>
              <FieldSet>
                <FieldItem>利用券区分</FieldItem>
                <Field name="org.ticketdiv" component={DropDown} items={ticketdivItems} addblank id="ticketdiv" />
              </FieldSet>
              <FieldSet>
                <FieldItem>利用券請求書添付</FieldItem>
                <Field component={CheckBox} name="org.ticketaddbill" checkedValue={1} label="要添付" id="ticketdiv" />
              </FieldSet>
              <FieldSet>
                <FieldItem>利用券事前回収</FieldItem>
                <Field component={CheckBox} name="org.ticketcentercall" checkedValue={1} label="有" id="ticketcentercall" />
              </FieldSet>
              <FieldSet>
                <FieldItem>利用券本人当日回収</FieldItem>
                <Field component={CheckBox} name="org.ticketpercall" checkedValue={1} label="有" id="ticketpercall" />
              </FieldSet>
              <FieldSet>
                <FieldItem>契約日付</FieldItem>
                <Field name="org.ctrptdate" component={DatePicker} id="ctrptdate" />
              </FieldSet>
              <FieldSet>
                <FieldItem>1年目はがき</FieldItem>
                <Field component={CheckBox} name="org.noprintletter" checkedValue={1} label="出力しない" id="noprintletter" />
              </FieldSet>
              <FieldSet>
                <FieldItem>保険証</FieldItem>
                <Field component={CheckBox} name="org.inscheck" checkedValue={1} label="予約時に確認する" />
                <Field component={CheckBox} name="org.insbring" checkedValue={1} label="当日持参して頂く" />
                <Field component={CheckBox} name="org.insreport" checkedValue={1} label="成績表に保険証記号、番号を出力" />
              </FieldSet>
              <FieldSet>
                <FieldItem>請求書</FieldItem>
                <FieldValueList>
                  <FieldValue>
                    <Label>適用住所：</Label>
                    <Field name="org.billaddress" component={DropDown} items={billaddressItems} addblank id="billaddress" />
                  </FieldValue>
                  <FieldValue>
                    <Field component={CheckBox} name="org.billcsldiv" checkedValue={1} label="本人、家族区分を出力" />
                    <Field component={CheckBox} name="org.billins" checkedValue={1} label="保険証記号、番号を出力" />
                    <Field component={CheckBox} name="org.billempno" checkedValue={1} label="社員番号を出力" />
                    <Field component={CheckBox} name="org.billage" checkedValue={1} label="年齢を出力" />
                  </FieldValue>
                  <FieldValue>
                    <Field component={Radio} name="org.billreport" checkedValue={1} label="３連成績書を添付" />
                    <Field component={Radio} name="org.billreport" checkedValue={2} label="法定項目成績書を添付" />
                    <Field component={Radio} name="org.billreport" checkedValue="" label="どちらも添付しない" />
                  </FieldValue>
                  <FieldValue>
                    <Field component={CheckBox} name="org.billspecial" checkedValue={1} label="特定健診成績書を添付" />
                    <Field component={CheckBox} name="org.billfd" checkedValue={1} label="FD発送" />
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
              <FieldSet>
                <FieldItem>成績書</FieldItem>
                <Field component={CheckBox} name="org.reptcsldiv" checkedValue={1} label="本人、家族区分を出力" id="reptcsldiv" />
                {isLoaded &&
                  <a
                    role="presentation"
                    style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}
                    onClick={() => onOpenOrgRptSetOptionGuide(orgRptSetOptionGuideConditions)}
                  >成績書オプション管理
                  </a>}
              </FieldSet>
              <FieldSet>
                <FieldItem>送付案内コメント（日本文）</FieldItem>
                <Field name="org.sendcomment" component={TextArea} id="sendcomment" style={{ width: 390, height: 50 }} />
              </FieldSet>
              <FieldSet>
                <FieldItem>送付案内コメント（英文）</FieldItem>
                <Field name="org.sendecomment" component={TextArea} id="sendecomment" style={{ width: 390, height: 50 }} />
              </FieldSet>
              <FieldSet>
                <FieldItem>汎用項目その１</FieldItem>
                <Field name="org.spare1" component={TextBox} id="spare1" style={{ width: 180 }} maxLength="12" />
                <Label>※保険者番号</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>汎用項目その２</FieldItem>
                <Field name="org.spare2" component={TextBox} id="spare2" style={{ width: 180 }} maxLength="12" />
                <Label>※組合番号</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>汎用項目その３</FieldItem>
                <Field name="org.spare3" component={TextBox} id="spare3" style={{ width: 180 }} maxLength="12" />
              </FieldSet>
              <div style={{ marginLeft: 200 }}>
                <span style={{ color: 'red', fontWeight: 'bold' }}>
                  2004/1/22更新:<br />
                  コメントはコメント情報として登録場所をまとめました。<br />
                  このページの最上部コメントボタンから登録してください。<br />
                  （請求関連コメントも最上部コメントボタンにまとめる予定です）
                </span>
              </div>
              <FieldSet>
                <FieldItem>請求関連コメント</FieldItem>
                <Field name="org.dmdcomment" component={TextArea} id="dmdcomment" style={{ width: 390, height: 50 }} />
              </FieldSet>
              <FieldSet>
                <FieldItem>更新日時</FieldItem>
                <Label>{formValues && formValues.org.upddate}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>オペレータID</FieldItem>
                <Label>{formValues && formValues.org.username}</Label>
              </FieldSet>
            </FieldGroup>
          </form>
        </div>
        <ZipGuide onSelected={this.handleSelectedZipGuide} />
        <CommentListFlameGuide orgcd1={match.params.orgcd1} orgcd2={match.params.orgcd2} dispmode="5" cmtmode="0,0,1,0" userid="HAINS$" />
        <RptSetOptionGuide orgName={formValues && formValues.org.orgname} />
      </PageLayout>
    );
  }
}

const OrgEditForm = reduxForm({
  form: formName,
})(OrgEdit);

OrgEdit.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  messageType: PropTypes.string.isRequired,
  formValues: PropTypes.shape(),
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  onOpenZipGuide: PropTypes.func.isRequired,
  onOpenOrgRptSetOptionGuide: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  targets: PropTypes.shape().isRequired,
  orgRptSetOptionGuideConditions: PropTypes.shape().isRequired,
  onShowGuideNote: PropTypes.func.isRequired,
};

OrgEdit.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  const selector = formValueSelector(formName);
  return {
    // 団体登録フォームの初期値設定
    initialValues: {
      org: {
        delflg: 2,
        postcard: 0,
        packagesend: 0,
        ticket: 0,
      },
      orgaddr: [
        {
          addrdiv: 1,
        },
        {
          addrdiv: 2,
        },
        {
          addrdiv: 3,
        },
      ],
    },
    formValues,
    message: state.app.preference.organization.organizationEdit.message,
    messageType: state.app.preference.organization.organizationEdit.messageType,
    // 郵便番号ガイドから選択した値をセットするフィールド名
    targets: state.app.preference.zip.targets,
    // 成績書オプション管理ガイドを開く際の初期条件
    orgRptSetOptionGuideConditions: {
      orgcd1: selector(state, 'org.orgcd1'),
      orgcd2: selector(state, 'org.orgcd2'),
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 画面を初期化
    dispatch(initializeOrg());
    const { orgcd1, orgcd2 } = params;
    // 団体コード1、団体コード2がなければ以降何もしない
    if (orgcd1 === undefined || orgcd2 === undefined) {
      return;
    }
    dispatch(getOrgRequest({ params, formName }));
  },
  onSubmit: (params, data, redirect) => dispatch(registerOrgRequest({ params, data, redirect })),
  onDelete: (params, redirect) => dispatch(deleteOrgRequest({ params, redirect })),
  // 郵便番号ガイド表示処理
  onOpenZipGuide: (targets, conditions) => {
    // 県コードがセットされていればガイドを開く前に郵便番号検索を行う
    if (conditions.prefcd) {
      const [page, limit] = [1, 20];
      dispatch(getZipListRequest({ page, limit, ...conditions }));
    }
    // targets:ガイドで選択した値を入れるフィールド名の連想配列
    // conditions:ガイドにの検索項目にセットする初期条件
    dispatch(openZipGuide({ targets, conditions }));
  },
  // 成績書オプション管理ガイド表示処理
  onOpenOrgRptSetOptionGuide: (conditions) => {
    // conditions:ガイドにの検索項目にセットする初期条件
    dispatch(openOrgRptSetOptionGuide({ conditions }));
  },
  // 情報コメント
  onShowGuideNote: (params) => {
    dispatch(openCommentListFlameGuide({ params }));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OrgEditForm);
