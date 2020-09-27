import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import { Field, reduxForm, getFormValues, getFormInitialValues, FormSection } from 'redux-form';
import { connect } from 'react-redux';
import moment from 'moment';
import { bindActionCreators } from 'redux';

import * as consultModules from '../../modules/reserve/consultModule';
import * as contractModules from '../../modules/reserve/contractModule';
import * as scheduleModules from '../../modules/reserve/scheduleModule';
import SectionBar from '../../components/SectionBar';
import Button from '../../components/control/Button';
import PageLayout from '../../layouts/PageLayout';
import GuideButton from '../../components/GuideButton';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../components/Field';
import MessageBanner from '../../components/MessageBanner';
import Label from '../../components/control/Label';
import DropDownDestination from '../../components/control/dropdown/DropDownDestination';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import CheckBox from '../../components/control/CheckBox';
import Radio from '../../components/control/Radio';
import Table from '../../components/Table';
import TextBox from '../../components/control/TextBox';

import OrgGuide from '../../containers/common/OrgGuide';
import { openOrgGuide } from '../../modules/preference/organizationModule';
import PersonGuide from '../../containers/common/PersonGuide';
import { openPersonGuide } from '../../modules/preference/personModule';
import EntryFromDetailGuide from '../../containers/common/EntryFromDetailGuide';
import PrintStatusGuide from '../../containers/common/PrintStatusGuide';
import CancelReceptionGuide from '../../containers/common/CancelReceptionGuide';
import CancelConsultGuide from '../../containers/common/CancelConsultGuide';
import DeleteSetItemGuide from '../../containers/common/DeleteSetItemGuide';

const rsvstatusItems = [{ value: 0, name: '確定' }, { value: 1, name: '保留' }, { value: 2, name: '未確定' }];

const volunteerItems = [{ value: 0, name: '利用なし' }, { value: 1, name: '通訳要' }, { value: 2, name: '介護要' }, { value: 3, name: '通訳＆介護要' }, { value: 4, name: '車椅子要' }];

const collectTicketItems = [{ value: 1, name: '回収済み' }];

const issueCslTicketItems = [{ value: 1, name: '新規' }, { value: 2, name: '既存' }, { value: 3, name: '再発行' }];

const sendMailDivItems = [{ value: 0, name: 'なし' }, { value: 1, name: '住所（自宅）' }, { value: 2, name: '住所（勤務先）' }, { value: 3, name: '住所（その他）' }];

const formName = 'reserveMain';

// 初期値
const initialValues = {
  consult: {
    csldate: moment().format('YYYY/MM/DD'),
    mode: 0,
  },
  consultdetail: {
    rsvstatus: 0,
    prtonsave: 1,
    cardaddrdiv: 1,
    cardouteng: 0,
    formaddrdiv: 1,
    formouteng: 0,
    reportaddrdiv: 1,
    reportoureng: 0,
    volunteer: 0,
    issuecslticket: 1,
    sendmaildiv: 0,
  },
};

const getPerAddr = (peraddr = [], addrdiv) => {
  // 住所情報の配列から指定の住所区分のレコードを取得する
  const rec = peraddr.filter((item) => item.addrdiv === addrdiv)[0];

  // 該当レコードがなければ空文字列を返す
  if (!rec) {
    return '';
  }

  // 各文字列を整形して結合する
  const zipcd = (rec.zipcd || '').replace(/^(.{3})(.+)$/, '$1-$2');
  const prefname = rec.prefname || '';
  const cityname = rec.cityname || '';
  const address1 = (rec.address1 || '').trim();
  const address2 = (rec.address2 || '').trim();

  return `${zipcd}${'　'}${prefname}${cityname}${address1}${address2}`;
};

const getTelInfo = (peraddr = [], addrdiv) => {
  // 住所情報の配列から指定の住所区分のレコードを取得する
  const rec = peraddr.filter((item) => item.addrdiv === addrdiv)[0];

  // 該当レコードがなければ空文字列を返す
  if (!rec) {
    return '';
  }

  // 電話番号情報を文字列変換
  const { tel1, phone, tel2 } = rec;
  const tels = [
    tel1 ? `電話1：${tel1}` : null,
    phone ? `携帯：${phone}` : null,
    tel2 ? `電話2：${tel2}` : null,
  ].filter(Boolean).join(',　');

  return tels.length > 0 ? `(${'　'}${tels}${'　'})` : '';
};

// コースコードから契約パターンコードを取得する
const getCtrPtCd = (cscd, courseData = []) => (
  courseData.filter((rec) => rec.cscd.toString() === cscd).map((rec) => rec.ctrptcd)[0]
);

class ReserveMain extends React.Component {
  constructor(props) {
    super(props);
    this.handleSelectedOrgGuide = this.handleSelectedOrgGuide.bind(this);
    this.handleSelectedPersonGuide = this.handleSelectedPersonGuide.bind(this);
    this.handleClickSave = this.handleClickSave.bind(this);
    this.handleClickNew = this.handleClickNew.bind(this);
    this.handleClickRceipt = this.handleClickRceipt.bind(this);
    this.handleReceipted = this.handleReceipted.bind(this);
    this.handleClickPrintStatus = this.handleClickPrintStatus.bind(this);
    this.handleClickCancelReceipt = this.handleClickCancelReceipt.bind(this);
    this.handleClickCancelReserve = this.handleClickCancelReserve.bind(this);
    this.handleClickDeleteSetItem = this.handleClickDeleteSetItem.bind(this);
  }

  componentDidMount() {
    const { consultActions, match } = this.props;

    // 画面初期化
    consultActions.initializeConsult();

    const { rsvno } = match.params;
    if (rsvno === undefined) {
      return;
    }

    consultActions.getConsultRequest({ params: match.params, formName });
  }

  componentWillReceiveProps(nextProps) {
    // 次のProps
    const nextconsult = nextProps.formValues.consult || {};
    const { orgcd1, orgcd2, csldate, cscd, csldivcd, rsvgrpcd, perid, gender, birth } = nextconsult;

    // 現在のProps
    const currentconsult = this.props.formValues.consult || {};

    // 団体コードか受診日に変更があればドロップダウンを更新する
    if (currentconsult.orgcd1 !== orgcd1 ||
      currentconsult.orgcd2 !== orgcd2 ||
      currentconsult.csldate !== csldate) {
      // コースの選択肢を更新
      this.replaceCourseItems(csldate, orgcd1, orgcd2);
    }

    // 団体コード、受診日、コースに変更があればドロップダウンを更新する
    if (currentconsult.orgcd1 !== orgcd1 ||
      currentconsult.orgcd2 !== orgcd2 ||
      currentconsult.csldate !== csldate ||
      currentconsult.cscd !== cscd) {
      // 受診区分の選択肢を更新
      this.replaceCslDivItems(csldate, orgcd1, orgcd2, cscd);
    }

    // コースコードか受診日が変更されれば予約群の選択肢を変更する
    if (currentconsult.csldate !== csldate ||
      currentconsult.cscd !== cscd) {
      this.replaceRsvGrpItems(csldate, cscd);
    }

    const { courseItems, csldivItems, rsvgrpItems, contractOptions, courseData } = nextProps;

    // 変更前と変更後の検査セットコード取得
    const ctrptcd = getCtrPtCd(cscd, courseData);
    this.props.change('consult.ctrptcd', ctrptcd);
    const currentctrptcd = getCtrPtCd(currentconsult.cscd, this.props.courseData);

    // 個人情報、受診日、コースコード、受診区分のどれかが変更されれば検査セットを変更する
    if (currentconsult.csldate !== csldate ||
      currentctrptcd !== ctrptcd ||
      currentconsult.csldivcd !== csldivcd ||
      currentconsult.perid !== perid ||
      currentconsult.gender !== gender ||
      currentconsult.birth !== birth
    ) {
      this.replaceOptions({ csldate, ctrptcd, csldivcd, perid, gender, birth });
    }

    // 選択肢が変更された際に現在選択中のコースコードが選択肢になければコースコードをクリアする
    if (JSON.stringify(this.props.courseItems) !== JSON.stringify(courseItems)) {
      if (!courseItems.filter((item) => item.value === cscd)[0]) {
        this.props.change('consult.cscd', '');
      }
    }

    // 選択肢が変更された際に現在選択中の受診区分が選択肢になければ受診区分をクリアする
    if (JSON.stringify(this.props.csldivItems) !== JSON.stringify(csldivItems)) {
      if (!csldivItems.filter((item) => item.value === csldivcd)[0]) {
        this.props.change('consult.csldivcd', '');
      }
    }

    // 選択肢が変更された際に現在選択中の予約群が選択肢になければ予約群をクリアする
    if (JSON.stringify(this.props.rsvgrpItems) !== JSON.stringify(rsvgrpItems)) {
      if (!rsvgrpItems.filter((item) => item.value === rsvgrpcd)[0]) {
        this.props.change('consult.rsvgrpcd', '');
      }
    }

    // 検査オプションの選択肢に変更があったらその内容に合わせて選択中の検査セットを変える
    if (JSON.stringify(this.props.contractOptions) !== JSON.stringify(contractOptions)) {
      this.adjustOptions(contractOptions);
    }
  }

  // コースの選択肢を更新
  replaceCourseItems(csldate, orgcd1, orgcd2) {
    const { contractActions } = this.props;
    if (!csldate || !orgcd1 || !orgcd2) {
      contractActions.initializeContractCourceItems();
      return;
    }
    contractActions.getContractCourceItemsRequest({ orgcd1, orgcd2, strdate: csldate, enddate: csldate });
  }

  // 受診区分の選択肢を更新
  replaceCslDivItems(csldate, orgcd1, orgcd2, cscd) {
    const { contractActions } = this.props;
    if (!csldate || !orgcd1 || !orgcd2) {
      contractActions.initializeContractCslDivItems();
      return;
    }
    contractActions.getContractCslDivItemsRequest({ orgcd1, orgcd2, strdate: csldate, enddate: csldate, cscd });
  }

  // 予約群の選択肢を更新
  replaceRsvGrpItems(csldate, cscd) {
    const { scheduleActions } = this.props;

    // 受診日がシステム日付より前であればすべての予約群をセット
    if (csldate && moment(csldate).isBefore(moment(), 'day')) {
      scheduleActions.getRsvGrpListAllRequest();
      return;
    }

    // コースコードか受診日がセットされていなければ予約群の選択肢を破棄
    if (!cscd || !csldate) {
      scheduleActions.initializeRsvGrp();
      return;
    }

    // コースコードに応じた予約群をセット
    scheduleActions.getRsvGrpListRequest({ cscd, sortorder: 0 });
  }

  // 検査セットを更新する
  replaceOptions(conditions) {
    const { csldate, ctrptcd, csldivcd, perid, gender, birth } = conditions;
    const { contractActions } = this.props;

    if (!csldate || !ctrptcd || !csldivcd || !perid || !gender || !birth) {
      contractActions.initializeContractOptions();
      return;
    }

    contractActions.getContractOptionsRequest({
      csldate,
      ctrptcd,
      csldivcd,
      perid,
      gender,
      birth,
      exceptnomatch: true,
      incluedetax: false,
      mode: 1,
    });
  }

  // 表示中の検査オプションの選択肢に合わせてredux-formで選択している検査オプションを変更する
  // redux-formで選択している検査オプションが変更後にも存在する場合、選択したままにする。
  // redux-formにないラジオボタンの選択肢の場合1行目を選択する。
  // redux-formで選択していた検査オプションが変更後になくなった場合は削除する。
  adjustOptions(contractOptions) {
    // 検査オプションの選択肢をオプションコード毎に配置しなおす
    const options = !contractOptions ? {} : contractOptions.reduce(
      (accum, rec) => {
        const { optcd, optbranchno, branchcount } = rec;
        const { optbranchnos = [] } = accum[optcd] || {};
        const value = {
          [optcd]: {
            // 検査オプション枝番を配列で保持する
            optbranchnos: [...optbranchnos, optbranchno],
            // 枝番数を保持する（ラジオボタンかチェックボックスかの判定に使う）
            branchcount,
          },
        };
        return { ...accum, ...value };
      },
      {},
    );

    const { change, formValues } = this.props;
    const { consultoptions = {} } = formValues;

    // 新しいredux-formの検査オプションをセットしなおす
    const newConsultoptions = Object.keys(options).reduce(
      (accum, optcd) => {
        // redux-formで保持している検査オプションコードと検査オプション枝番が一致している選択肢が存在する場合
        // つまり、変更前に選択した検査オプションが変更後にもある場合、現在のredux-formの値を保持する
        if (options[optcd].optbranchnos.indexOf(consultoptions[optcd]) >= 0) {
          return { ...accum, [optcd]: consultoptions[optcd] };
        }
        // redux-formで保持している検査オプションコードと検査オプション枝番が一致している選択肢がないラジオボタンの場合
        // つまり、変更前に選択した検査オプションが変更後に存在せず、その検査オプションがラジオボタンの場合、１行目の値をセットする
        if (options[optcd].branchcount !== 1) {
          return { ...accum, [optcd]: options[optcd].optbranchnos[0] };
        }
        // 上記以外の場合は何もしない
        return accum;
      },
      {},
    );

    // 検査オプションの選択値をセットする
    change('consultoptions', newConsultoptions);
  }

  // 団体ガイド一覧選択時処理
  handleSelectedOrgGuide(item, targets) {
    const { change } = this.props;
    const { orgcd1, orgcd2, orgname, orgsname } = item.org;
    change(targets.orgcd1, orgcd1);
    change(targets.orgcd2, orgcd2);
    change(targets.orgname, orgname);
    change(targets.orgsname, orgsname);
  }

  // 個人ガイド一覧選択処理
  handleSelectedPersonGuide(item, targets) {
    const { change, consultActions } = this.props;
    const { perid, lastname, firstname, lastkname, firstkname, birth, gender } = item;
    change(targets.perid, perid);
    change(targets.lastname, lastname);
    change(targets.firstname, firstname);
    change(targets.lastkname, lastkname);
    change(targets.firstkname, firstkname);
    change(targets.birth, birth);
    change(targets.gender, gender);

    // 誕生日から年齢を計算
    consultActions.calcAgeRequest({
      conditions: { birth },
      callback: (payload) => {
        if (!payload) {
          return change(targets.age, null);
        }
        return change(targets.age, payload.realAge);
      },
    });
  }

  // 新規ボタンクリック処理
  handleClickNew() {
    const { history, consultActions, initialize } = this.props;
    history.replace('/contents/reserve/main');
    consultActions.initializeConsult();
    initialize(initialValues);
  }

  // リダイレクト処理
  handleRedirect(rsvno) {
    const { history, consultActions } = this.props;
    history.replace(`/contents/reserve/main/${rsvno}`);
    consultActions.getConsultRequest({ params: { rsvno }, formName });
  }

  // 保存ボタンクリック処理
  handleClickSave(entryValues = {}) {
    const { match: { params } = {}, consultActions, formValues } = this.props;

    // 保存データ再構築
    const data = { ...formValues, consult: { ...formValues.consult, ...entryValues } };

    // 登録処理
    consultActions.registerConsultRequest({
      params,
      data,
      redirect: (payload) => {
        const rsvno = params.rsvno || payload.rsvno;
        this.handleRedirect(rsvno);
      },
    });
  }

  // 受付ボタンクリック処理
  handleClickRceipt(data) {
    const { consultActions } = this.props;
    consultActions.openEntryFromDetailGuideRequest(data);
  }

  // 受付実行処理
  handleReceipted(items) {
    this.handleClickSave(items);
  }

  // 印刷状況クリック処理
  handleClickPrintStatus() {
    const { match: { params } = {}, consultActions } = this.props;
    const { rsvno } = params;
    consultActions.openPrintStatusGuide({ rsvno });
  }

  // 受付取消クリック時処理
  handleClickCancelReceipt() {
    const { consultActions, match: { params } = {} } = this.props;
    consultActions.openCancelReceptionGuide({
      data: { rsvno: params.rsvno, cancelflg: 0 },
      // 受付取り消し後処理
      onSelected: (values) => {
        consultActions.setMessages(values.messages);
        this.handleRedirect(params.rsvno);
      },
    });
  }

  // キャンセルボタンクリック処理
  handleClickCancelReserve(rsvno) {
    const { consultActions } = this.props;
    consultActions.openCancelConsultGuide({
      rsvno,
      redirect: () => {
        this.handleRedirect(rsvno);
      },
    });
  }

  // セット内項目削除ボタンクリック処理
  handleClickDeleteSetItem({ rsvno, ctrptcd, optcd, optbranchno }) {
    const { consultActions } = this.props;
    consultActions.openConsultDeleteItemGuide({
      rsvno,
      ctrptcd,
      optcd,
      optbranchno,
    });
  }

  render() {
    const {
      formValues,
      formInitialValues,
      onOpenPersonGuide,
      onOpenOrgGuide,
      courseItems,
      csldivItems,
      rsvgrpItems,
      contractOptions = [],
      editState,
      match,
    } = this.props;

    // 受診者情報を取得
    const { consult = {}, consultdetail = {} } = formValues;

    // 団体情報を取得
    const orgbase = formValues.org || {};
    const { org = {} } = orgbase;

    const { peraddr = [], introductor = {}, persondetail = {} } = formValues;

    // 受診者情報の初期値を取得
    const initialconsultbase = formInitialValues.consult || {};
    const initialconsult = initialconsultbase.consult || {};

    return (
      <PageLayout title="受診情報詳細">
        <MessageBanner messages={editState.messages} />
        <form>
          <div>
            <Button value="キャンセル" onClick={() => this.handleClickCancelReserve(consult.rsvno)} />
            <Button value="新規" onClick={() => this.handleClickNew()} />
            <Button value="保存" onClick={() => this.handleClickSave()} />
            <Button value="コメント" />
            <Button value="受診歴" />
            <Button value="お連れ様" />
            <Button value="予約状況" />
            <Button value="受診金額" />
            <Button
              value="受付"
              onClick={() => this.handleClickRceipt({
                params: { ...match.params },
                data: { ...formValues },
                onSelected: (items) => this.handleReceipted(items),
                })
              }
            />
            <Button value="受付取消" onClick={() => this.handleClickCancelReceipt()} />
            <Button value="来院" />
          </div>
          <SectionBar title="基本情報" />
          {consult.cancelflg !== undefined && consult.cancelflg !== 0 &&
            <div>
              この受診情報はキャンセルされています。キャンセル理由：{editState.cancelReasonName}
            </div>
          }
          <FieldGroup itemWidth={100}>
            <FormSection name="consult">
              <FieldSet>
                <FieldItem>個人名</FieldItem>
                <GuideButton onClick={() =>
                  onOpenPersonGuide({ onSelected: (item) =>
                      this.handleSelectedPersonGuide(item, {
                        perid: 'consult.perid',
                        firstname: 'consult.firstname',
                        lastname: 'consult.lastname',
                        firstkname: 'consult.firstkname',
                        lastkname: 'consult.lastkname',
                        age: 'consult.age',
                        birth: 'consult.birth',
                        gender: 'consult.gender',
                      }),
                    })
                  }
                />
                <Label>{consult.perid}</Label>
                <Label>
                  <ruby>
                    <Link to="">{consult.lastname} {consult.firstname}</Link>
                    <rt>{consult.lastkname} {consult.firstkname}</rt>
                  </ruby>
                </Label>
                <Label>{consult.birth && `${consult.birth}生`}</Label>
                <Label>{consult.age && `${consult.age}歳`}</Label>
                <Label>
                  {consult.gender === 1 && '男性'}
                  {consult.gender === 2 && '女性'}
                </Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>団体</FieldItem>
                <GuideButton onClick={() =>
                  onOpenOrgGuide({ onSelected: (item) =>
                    this.handleSelectedOrgGuide(item, {
                        orgcd1: 'consult.orgcd1',
                        orgcd2: 'consult.orgcd2',
                        orgname: 'consult.orgname',
                        orgsname: 'consult.orgsname',
                      }),
                    })
                  }
                />
                <Label>{consult.orgname}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>コース</FieldItem>
                <Field name="cscd" component={DropDown} items={courseItems} addblank />
                <FieldItem>受診区分</FieldItem>
                <Field name="csldivcd" component={DropDown} items={csldivItems} addblank />
              </FieldSet>
              <FieldSet>
                <FieldItem>予約番号</FieldItem>
                <Label>{consult.rsvno}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>受診日時</FieldItem>
                <Field component={DatePicker} name="csldate" />
                <Field component={DropDown} name="rsvgrpcd" items={rsvgrpItems} addblank />
              </FieldSet>
              <FieldSet>
                <FieldItem>当日ID</FieldItem>
                <Label>{consult.dayid}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>現受診日</FieldItem>
                <Label>{initialconsult.csldate}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>関連健診</FieldItem>
                <GuideButton />
                <Label>{consult.firstcsldate}</Label>
                <Label>{consult.firstcslname}</Label>
              </FieldSet>
              <FieldSet>
                <Field name="ignoreflg" component={CheckBox} label="強制登録を行う" checkedValue={1} />
              </FieldSet>
            </FormSection>
          </FieldGroup>
          <SectionBar title="検査セット" />
          <FieldGroup>
            {!contractOptions && (
              <span>基本情報を入力して下さい。</span>
            )}
            {contractOptions && (
              <div>
                <FieldSet>
                  <FieldItem>
                    パターンNo.
                  </FieldItem>
                  <Label>
                    {consult.ctrptcd}
                  </Label>
                  <Label>
                    <Link to="">この契約を参照</Link>
                  </Label>
                  <Field component={CheckBox} name="showall" checkedValue={1} label="すべての検査を" />
                  <Button value="再表示" />
                </FieldSet>
                <FieldSet>
                  {contractOptions.length <= 0 && (
                    <span>この契約情報のオプション検査は存在しません。</span>
                  )}
                  {contractOptions.length > 0 && (
                    <Table striped hover>
                      <thead>
                        <tr>
                          <th colSpan="2">検査セット名（一日人間ドック）</th>
                          <th>負担金額計</th>
                          <th>個人負担分</th>
                          <th>セット内</th>
                          <th>情報</th>
                          <th />
                        </tr>
                      </thead>
                      <tbody>
                        {contractOptions.map((rec) => {
                          const price = Number.isNaN(rec.price) ? '' : rec.price.toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,');
                          const perprice = Number.isNaN(rec.perprice) ? '' : rec.perprice.toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,');
                          return (
                            <tr key={`${rec.optcd}-${rec.optbranchno}`}>
                              <td>
                                <Field component={rec.branchcount === 1 ? CheckBox : Radio} name={`consultoptions.${rec.optcd}`} checkedValue={rec.optbranchno} />
                              </td>
                              <td>
                                <span style={{ color: `#${rec.setcolor}` }}>●</span>
                                <span>{rec.optname}</span>
                              </td>
                              <td style={{ textAlign: 'right' }}>
                                {price && <span>&yen;{price}</span>}
                              </td>
                              <td style={{ textAlign: 'right' }}>
                                {perprice && <span>&yen;{perprice}</span>}
                              </td>
                              <td style={{ textAlign: 'center' }}>
                                <Button
                                  value="削除"
                                  onClick={() => this.handleClickDeleteSetItem({
                                    rsvno: consult.rsvno,
                                    ctrptcd: consult.ctrptcd,
                                    optcd: rec.optcd,
                                    optbranchno: rec.optbranchno,
                                  })}
                                />
                              </td>
                              <td style={{ textAlign: 'center' }}>
                                <Link to="">情報</Link>
                              </td>
                              <td style={{ textAlign: 'right' }}>
                                {`${rec.optcd}-${rec.optbranchno}`}
                              </td>
                            </tr>
                          );
                        })}
                      </tbody>
                    </Table>
                  )}
                </FieldSet>
              </div>
            )}
          </FieldGroup>
          <SectionBar title="受診付属情報" />
          <FieldGroup itemWidth={150}>
            <FormSection name="consultdetail">
              <FieldSet>
                <FieldItem>予約状況</FieldItem>
                <Field component={DropDown} name="rsvstatus" items={rsvstatusItems} />
              </FieldSet>
              <FieldSet>
                <FieldItem>保存時印刷</FieldItem>
                <Field component={Radio} name="prtonsave" checkedValue={0} label="なし" />
                <Field component={Radio} name="prtonsave" checkedValue={1} label="はがき" />
                <Field component={Radio} name="prtonsave" checkedValue={2} label="送付案内" />
              </FieldSet>
              <FieldSet>
                <FieldItem>宛先（確認はがき）</FieldItem>
                <Field name="cardaddrdiv" component={DropDownDestination} />
                <Label>英文出力</Label>
                <Field component={Radio} name="cardouteng" checkedValue={1} label="有" />
                <Field component={Radio} name="cardouteng" checkedValue={0} label="無" />
              </FieldSet>
              <FieldSet>
                <FieldItem>宛先（一式書式）</FieldItem>
                <Field name="formaddrdiv" component={DropDownDestination} />
                <Label>英文出力</Label>
                <Field component={Radio} name="formouteng" checkedValue={1} label="有" />
                <Field component={Radio} name="formouteng" checkedValue={0} label="無" />
              </FieldSet>
              <FieldSet>
                <FieldItem>宛先（成績表）</FieldItem>
                <Field name="reportaddrdiv" component={DropDownDestination} />
                <Label>英文出力</Label>
                <Field component={Radio} name="reportoureng" checkedValue={1} label="有" />
                <Field component={Radio} name="reportoureng" checkedValue={0} label="無" />
              </FieldSet>
              <FieldSet>
                <Button value="印刷状況を見る" onClick={() => this.handleClickPrintStatus()} />
              </FieldSet>
              <FieldSet>
                <FieldItem>住所（自宅）</FieldItem>
                <FieldValueList>
                  <FieldValue>
                    <Label>{getPerAddr(peraddr, 1)}</Label>
                  </FieldValue>
                  <FieldValue>
                    <Label>{getTelInfo(peraddr, 1)}</Label>
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
              <FieldSet>
                <FieldItem>住所（勤務先）</FieldItem>
                <FieldValueList>
                  <FieldValue>
                    <Label>{getPerAddr(peraddr, 2)}</Label>
                  </FieldValue>
                  <FieldValue>
                    <Label>{getTelInfo(peraddr, 2)}</Label>
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
              <FieldSet>
                <FieldItem>住所（その他）</FieldItem>
                <FieldValueList>
                  <FieldValue>
                    <Label>{getPerAddr(peraddr, 3)}</Label>
                  </FieldValue>
                  <FieldValue>
                    <Label>{getTelInfo(peraddr, 3)}</Label>
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
              <FieldSet>
                <FieldItem>特記事項</FieldItem>
                <Label>{persondetail.notes}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>送付案内コメント</FieldItem>
                <Label>{org.sendcomment}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>ボランティア</FieldItem>
                <Field name="volunteer" component={DropDown} items={volunteerItems} />
              </FieldSet>
              <FieldSet>
                <FieldItem>ボランティア名</FieldItem>
                <Field name="volunteername" component={TextBox} />
              </FieldSet>
              <FieldSet>
                <FieldItem>利用権回収</FieldItem>
                <Field name="collectticket" component={DropDown} items={collectTicketItems} addblank blankname="未回収" />
              </FieldSet>
              <FieldSet>
                <FieldItem>診察券発行</FieldItem>
                <Field name="issuecslticket" component={DropDown} items={issueCslTicketItems} addblank />
              </FieldSet>
              <FieldSet>
                <FieldItem>保険証記号</FieldItem>
                <Field name="isrsign" component={TextBox} />
              </FieldSet>
              <FieldSet>
                <FieldItem>保険証番号</FieldItem>
                <Field name="isrno" component={TextBox} />
              </FieldSet>
              <FieldSet>
                <FieldItem>保険者番号</FieldItem>
                <Field name="isrmanno" component={TextBox} />
              </FieldSet>
              <FieldSet>
                <FieldItem>社員番号</FieldItem>
                <Field name="empno" component={TextBox} />
              </FieldSet>
              <FieldSet>
                <FieldItem>紹介者名</FieldItem>
                <GuideButton />
                <Label>
                  {`${introductor.lastname || ''}${'　'}${introductor.firstname || ''}`.trim()}
                </Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>予約確認メール</FieldItem>
                <Field name="sendmaildiv" component={DropDown} items={sendMailDivItems} />
              </FieldSet>
              <FieldSet>
                <FieldItem>メール送信日時</FieldItem>
                <Label>{consultdetail.sendmaildate}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>メール送信者</FieldItem>
                <Label>{consultdetail.username}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>変更前予約日</FieldItem>
                <Label>{consultdetail.lastcsldate}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>更新日時</FieldItem>
                <Label>{consult.upddate}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>更新者</FieldItem>
                <Label>{consult.username}</Label>
              </FieldSet>
            </FormSection>
          </FieldGroup>
        </form>
        <PersonGuide />
        <OrgGuide />
        <EntryFromDetailGuide />
        <PrintStatusGuide />
        <CancelReceptionGuide />
        <CancelConsultGuide />
        <DeleteSetItemGuide />
      </PageLayout>
    );
  }
}

ReserveMain.propTypes = {
  editState: PropTypes.shape().isRequired,
  formValues: PropTypes.shape(),
  formInitialValues: PropTypes.shape(),
  initialize: PropTypes.func.isRequired,
  consultActions: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  change: PropTypes.func.isRequired,
  courseItems: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  courseData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  csldivItems: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  rsvgrpItems: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  contractOptions: PropTypes.arrayOf(PropTypes.shape()),
  onOpenOrgGuide: PropTypes.func.isRequired,
  onOpenPersonGuide: PropTypes.func.isRequired,
  contractActions: PropTypes.shape().isRequired,
  scheduleActions: PropTypes.shape().isRequired,
};

ReserveMain.defaultProps = {
  formValues: {},
  formInitialValues: {},
  contractOptions: null,
};

const ReserveMainForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(ReserveMain);

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  const formInitialValues = getFormInitialValues(formName)(state);
  return {
    initialValues,
    editState: state.app.reserve.consult.edit,
    formValues,
    formInitialValues,
    courseItems: state.app.reserve.contract.course.items,
    courseData: state.app.reserve.contract.course.data,
    csldivItems: state.app.reserve.contract.csldiv.items,
    rsvgrpItems: state.app.reserve.schedule.rsvgrp.items,
    contractOptions: state.app.reserve.contract.options,
  };
};

const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModules, dispatch),
  onOpenPersonGuide: (payload) => {
    dispatch(openPersonGuide(payload));
  },
  onOpenOrgGuide: (payload) => {
    dispatch(openOrgGuide(payload));
  },
  contractActions: bindActionCreators(contractModules, dispatch),
  scheduleActions: bindActionCreators(scheduleModules, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(ReserveMainForm);
