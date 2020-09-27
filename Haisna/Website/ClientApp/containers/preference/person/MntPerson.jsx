import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import { Field, FieldArray, getFormValues, reduxForm, initialize, blur } from 'redux-form';
import { connect } from 'react-redux';
import PageLayout from '../../../layouts/PageLayout';
import MessageBanner from '../../../components/MessageBanner';
import { initializePerson, getPersonRequest, registerPersonRequest, deletePersonRequest, openPersonGuide, getFreeRequest, setPersonOrgTargetRequest } from '../../../modules/preference/personModule';
import { openOrgGuide } from '../../../modules/preference/organizationModule';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import DropDown from '../../../components/control/dropdown/DropDown';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import Label from '../../../components/control/Label';
import Chip from '../../../components/Chip';
import DropDownGender from '../../../components/control/dropdown/DropDownGender';
import ZipGuide from '../../common/ZipGuide';
import TextArea from '../../../components/control/TextArea';
import TextBox from '../../../components/control/TextBox';
import Button from '../../../components/control/Button';
import { openZipGuide, getZipListRequest } from '../../../modules/preference/zipModule';
import DropDownDelFlg from '../../../components/control/dropdown/DropDownDelFlg';
import GuideButton from '../../../components/GuideButton';
import SectionBar from '../../../components/SectionBar';
import PersonAddresses from './PersonAddresses';
import DropDownDestination from '../../../components/control/dropdown/DropDownDestination';
import DropDownFreeValue from '../../../components/control/dropdown/DropDownFreeValue';
import PersonGuide from '../../common/PersonGuide';
import OrgGuide from '../../common/OrgGuide';

// 婚姻区分
const marryItems = [{ value: 1, name: '未婚' }, { value: 2, name: '既婚' }];

const formName = 'PersonForm';

// 汎用項目編集
const SpareName = (props) => {
  const { freeValues } = props;
  const res = [];
  for (let i = 0; i < freeValues.length; i += 1) {
    let spareName = `汎用キー(${i})`;
    if (freeValues[i] !== '') {
      spareName = freeValues[i];
    }
    if (i < 2) {
      res.push(<FieldSet key={i.toString()}><FieldItem>{spareName}</FieldItem><Field name={`per.spare${i + 1}`} component={TextBox} style={{ width: 240 }} maxLength="16" /></FieldSet>);
    } else {
      res.push(<FieldSet key={i.toString()}><FieldItem>{spareName}</FieldItem><Field name={`perdetail.spare${i - 1}`} component={TextBox} style={{ width: 240 }} maxLength="20" /></FieldSet>);
    }
  }
  return res;
};

class MntPerson extends React.Component {
  constructor(props) {
    super(props);
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleInsertClick = this.handleInsertClick.bind(this);
    this.handleSelectedZipGuide = this.handleSelectedZipGuide.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleRevertClick = this.handleRevertClick.bind(this);
    this.handleCheckClick = this.handleCheckClick.bind(this);
  }

  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // 団体ガイドの行選択時イベント
  onSelected = (data) => {
    const { setValue, orgGuideTargets } = this.props;
    // 郵便番号をセット
    setValue(orgGuideTargets.zipcd, data.orgaddr[0].zipcd);
    // 都道府県コードをセット
    setValue(orgGuideTargets.prefcd, data.orgaddr[0].prefcd);
    // 市区町村
    setValue(orgGuideTargets.cityname, data.orgaddr[0].cityname);
    // 住所１
    setValue(orgGuideTargets.address1, data.orgaddr[0].address1);
    // 住所１
    setValue(orgGuideTargets.address2, data.orgaddr[0].address2);
    // 電話番号直通
    setValue(orgGuideTargets.tel1, data.orgaddr[0].directtel);
    // 電話番号代表
    setValue(orgGuideTargets.tel2, data.orgaddr[0].tel);
    // 内線
    setValue(orgGuideTargets.extension, data.orgaddr[0].extension);
    // ＦＡＸ
    setValue(orgGuideTargets.fax, data.orgaddr[0].fax);
    // e-Mail
    setValue(orgGuideTargets.email, data.orgaddr[0].email);
  }

  // 同伴者ガイドの行選択時イベント
  onPersonSelected = (data) => {
    const { setValue } = this.props;
    // 同伴者ID
    setValue('per.compperid', data.perid);
    // 同伴者姓
    setValue('per.complastname', data.lastname);
    // 同伴者名
    setValue('per.compfirstname', data.firstname);
  }

  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { history } = this.props;
    history.push('/contents/preference/person');
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

  // 個人情報登録時イベント
  handleSubmit(values) {
    const { history, match, onSubmit } = this.props;
    onSubmit(match.params, values, (refperid) => history.replace(`/contents/preference/person/edit/${refperid}`));
  }

  // 個人情報削除時イベント
  handleRemoveClick() {
    const { onDelete, match, history, onInitialize } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('このデータを削除しますか？')) {
      return;
    }
    onDelete(match.params, () => history.replace('/contents/preference/person/edit'), () => onInitialize(this.props, 'del'));
  }

  // 個人情報新規時イベント
  handleInsertClick() {
    const { history, onInitialize } = this.props;
    onInitialize(this.props);
    history.push('/contents/preference/person/edit');
  }

  // 検査情報遷移時イベント
  handleCheckClick() {
    const { history, formValues } = this.props;
    const { perid } = formValues.per;

    history.push(`/contents/preference/person/${perid}/inspection`);
  }
  // 医事情報複写時イベント
  handleRevertClick() {
    let s1;
    let s2;
    let s3;
    const { formValues } = this.props;

    s1 = formValues.per.medname === undefined || formValues.per.medname === null ? '' : formValues.per.medname;
    if (s1.indexOf('　') >= 0) {
      s2 = s1.substring(0, s1.indexOf('　'));
      s3 = s1.substring(s1.indexOf('　') + 1);
      this.props.change('per.lastname', s2);
      this.props.change('per.firstname', s3);
    } else {
      this.props.change('per.lastname', s1);
      this.props.change('per.firstname', '');
    }

    s1 = formValues.per.medkname === undefined || formValues.per.medkname === null ? '' : formValues.per.medkname;
    if (s1.indexOf('　') >= 0) {
      s2 = s1.substring(0, s1.indexOf('　'));
      s3 = s1.substring(s1.indexOf('　') + 1);
      this.props.change('per.lastkname', s2);
      this.props.change('per.firstkname', s3);
    } else {
      this.props.change('per.lastkname', s1);
      this.props.change('per.firstkname', '');
    }

    this.props.change('per.birth', formValues.per.medbirth === undefined || formValues.per.medbirth === null ? '' : formValues.per.medbirth);
    this.props.change('per.gender', formValues.per.medgender);

    this.props.change('peraddr[0].zipcd', formValues.peraddr[1].zipcd);
    this.props.change('peraddr[0].cityname', formValues.peraddr[1].cityname);
    this.props.change('peraddr[0].address1', formValues.peraddr[1].address1);
    this.props.change('peraddr[0].address2', formValues.peraddr[1].address2);
    this.props.change('peraddr[0].tel1', formValues.peraddr[1].tel1);
    this.props.change('peraddr[0].phone', formValues.peraddr[1].phone);
    this.props.change('peraddr[0].tel2', formValues.peraddr[1].tel2);
    this.props.change('peraddr[0].extension', formValues.peraddr[1].extension);
    this.props.change('peraddr[0].fax', formValues.peraddr[1].fax);
    this.props.change('peraddr[0].email', formValues.peraddr[1].email);
  }

  render() {
    const { match, formValues, handleSubmit, message, onOpenZipGuide, onOpenPersonGuide, onOpenOrgGuide, setValue } = this.props;
    const isLoaded = match.params.perid !== undefined;

    return (
      <PageLayout title="個人情報メンテナンス">
        <div>
          <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
            <div>
              <Button onClick={this.handleCancelClick} value="戻る" />
              {(isLoaded === true) && <Button onClick={this.handleCheckClick} value="検査情報" />}
              {(isLoaded === true) && <Button onClick={this.handleRemoveClick} value="削除" />}
              <Button onClick={this.handleInsertClick} value="新規" />
              <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
              {(isLoaded === true) && <Button value="付け替え" />}
            </div>
            <MessageBanner messages={message} />
            <FieldGroup itemWidth={200}>
              <FieldSet>
                <FieldItem>個人ＩＤ</FieldItem>
                <Label>{isLoaded && match.params.perid}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>フリガナ</FieldItem>
                姓&nbsp;
                <Field name="per.lastkname" component={TextBox} id="perlastname" style={{ width: 180 }} maxLength="25" />
                &nbsp;名&nbsp;
                <Field name="per.firstkname" component={TextBox} id="perfirstname" style={{ width: 130 }} maxLength="25" />
              </FieldSet>
              <FieldSet>
                <FieldItem>名前</FieldItem>
                姓&nbsp;
                <Field name="per.lastname" component={TextBox} id="perlastname" style={{ width: 180 }} maxLength="25" />
                &nbsp;名&nbsp;
                <Field name="per.firstname" component={TextBox} id="perfirstname" style={{ width: 130 }} maxLength="25" />
              </FieldSet>
              <FieldSet>
                <FieldItem>ローマ字名</FieldItem>
                <Field name="per.romename" component={TextBox} id="perromename" style={{ width: 390 }} maxLength="60" />
              </FieldSet>
              <FieldSet>
                <FieldItem>性別</FieldItem>
                <Field name="per.gender" component={DropDownGender} id="pergender" addblank />
              </FieldSet>
              <FieldSet>
                <FieldItem>生年月日</FieldItem>
                <Field name="per.birth" component={DatePicker} id="perbirth" />
              </FieldSet>
              <FieldSet>
                <FieldItem>使用状態</FieldItem>
                <Field name="per.delflg" component={DropDownDelFlg} id="perdelflg" />
              </FieldSet>
              <FieldSet>
                <FieldItem>同伴者名</FieldItem>
                <GuideButton onClick={() => onOpenPersonGuide({ onSelected: this.onPersonSelected })} />
                {formValues && formValues.per.compperid && <Chip
                  label={`${formValues && formValues.per.complastname}${'　'}${formValues && formValues.per.compfirstname}${'　'}${formValues && formValues.per.compperid}`}
                  onDelete={() => {
                    setValue('per.compperid', '');
                    setValue('per.complastname', '');
                    setValue('per.compfirstname', '');
                  }}
                />}
                <PersonGuide />
              </FieldSet>
            </FieldGroup>
            <SectionBar title="医事情報" />
            <Button onClick={this.handleRevertClick} value="医事情報を複写" />
            <FieldGroup itemWidth={200}>
              <FieldSet>
                <FieldItem>漢字氏名</FieldItem>
                <Label>{formValues && formValues.per.medname}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>カナ氏名</FieldItem>
                <Label>{formValues && formValues.per.medkname}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>ローマ字氏名</FieldItem>
                <Label>{formValues && formValues.per.medrname}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>生年月日</FieldItem>
                {(formValues && formValues.per.medbirth === null) || (formValues && formValues.per.medbirth === undefined) ? ''
                  : <Label>{formValues && formValues.per.medbirthjp}</Label>}
              </FieldSet>
              <FieldSet>
                <FieldItem>性別</FieldItem>
                {formValues && formValues.per.medgender === null && (
                  <Label>{formValues && formValues.per.medgender}</Label>
                )}
                {formValues && formValues.per.medgender === 1 && (
                  <Label>男性</Label>
                )}
                {formValues && formValues.per.medgender === 2 && (
                  <Label>女性</Label>
                )}
              </FieldSet>
              <FieldSet>
                <FieldItem>更新日時</FieldItem>
                {(formValues && formValues.per.medupddate === null) || (formValues && formValues.per.medbirth === undefined) ? ''
                  : <Label>{moment(formValues && formValues.per.medupddate).format('YYYY/MM/DD HH:mm:ss')}</Label>}
              </FieldSet>
            </FieldGroup>
            <FieldArray name="peraddr" component={PersonAddresses} onOpenZipGuide={onOpenZipGuide} onSelected={this.onSelected} onOpenOrgGuide={onOpenOrgGuide} formName={formName} />
            <FieldGroup itemWidth={200}>
              <FieldSet>
                <FieldItem>宛先（一年目のはがき）</FieldItem>
                <Field name="per.postcardaddr" component={DropDownDestination} id="perdestination" />
              </FieldSet>
              <FieldSet>
                <FieldItem>婚姻区分</FieldItem>
                <Field name="perdetail.marriage" component={DropDown} items={marryItems} addblank />
              </FieldSet>
              <FieldSet>
                <FieldItem>旧姓</FieldItem>
                <Field name="per.maidenname" component={TextBox} id="permaidenname" style={{ width: 390 }} maxLength="16" />
              </FieldSet>
              <FieldSet>
                <FieldItem>受診回数</FieldItem>
                <Field name="per.cslcount" component={TextBox} id="percslcount" style={{ width: 60 }} maxLength="3" />
              </FieldSet>
              <FieldSet>
                <FieldItem>国籍</FieldItem>
                <Field name="per.nationcd" component={DropDownFreeValue} freecd="nation" addblank />
              </FieldSet>
              <FieldSet>
                <FieldItem>住民番号</FieldItem>
                <Field name="perdetail.residentno" component={TextBox} id="perdetailresidentno" style={{ width: 240 }} maxLength="15" />
              </FieldSet>
              <FieldSet>
                <FieldItem>組合番号</FieldItem>
                <Field name="perdetail.unionno" component={TextBox} id="perdetailunionno" style={{ width: 240 }} maxLength="15" />
              </FieldSet>
              <FieldSet>
                <FieldItem>カルテ番号</FieldItem>
                <Field name="perdetail.karte" component={TextBox} id="perdetailkarte" style={{ width: 240 }} maxLength="15" />
              </FieldSet>
              <SpareName {...this.props} />
              <FieldSet>
                <FieldItem>特記事項</FieldItem>
                <Field name="perdetail.notes" component={TextArea} id="perdetailnotes" style={{ width: 400, height: 50 }} />
              </FieldSet>
              <FieldSet>
                <FieldItem>更新日時</FieldItem>
                {(formValues && formValues.per.upddate === null) || (formValues && formValues.per.medbirth === undefined) ? ''
                  : <Label> {moment(formValues && formValues.per.upddate).format('YYYY/MM/DD HH:mm:ss')}</Label>}
              </FieldSet>
              <FieldSet>
                <FieldItem>更新者</FieldItem>
                <Label>{formValues && formValues.per.username}</Label>
              </FieldSet>
            </FieldGroup>
          </form>
        </div>
        <ZipGuide onSelected={this.handleSelectedZipGuide} />
        <OrgGuide />
      </PageLayout>
    );
  }
}

const MntPersonForm = reduxForm({
  form: formName,
})(MntPerson);

MntPerson.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  formValues: PropTypes.shape(),
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onOpenZipGuide: PropTypes.func.isRequired,
  targets: PropTypes.shape().isRequired,
  onDelete: PropTypes.func.isRequired,
  onOpenPersonGuide: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  onInitialize: PropTypes.func.isRequired,
  change: PropTypes.func.isRequired,
  freeValues: PropTypes.arrayOf(PropTypes.string).isRequired,
  onOpenOrgGuide: PropTypes.func.isRequired,
  perid: PropTypes.string,
  orgGuideTargets: PropTypes.shape().isRequired,
};

MntPerson.defaultProps = {
  formValues: undefined,
  perid: '',
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    // 個人登録フォームの初期値設定
    initialValues: {
      per: {
        delflg: 0,
        perid: '',
        vidflg: 1,
        postcardaddr: '1',
      },
      peraddr: [
        {
          addrdiv: 1,
        },
        {
          addrdiv: 4,
        },
        {
          addrdiv: 2,
        },
        {
          addrdiv: 3,
        },
      ],

      perdetail: {
      },
    },
    formValues,
    message: state.app.preference.person.personEdit.message,
    freeValues: state.app.preference.person.freeList.freeValues,
    targets: state.app.preference.zip.targets,
    orgGuideTargets: state.app.preference.person.personEdit.orgGuideTargets,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 画面を初期化
    dispatch(initializePerson());

    if (params.perid != null && params.perid !== undefined) {
      dispatch(getPersonRequest({ params, formName }));
    }
    dispatch(getFreeRequest());
  },
  onInitialize: (props, act) => {
    // 画面を初期化
    const { initialValues } = props;
    if (act !== 'del') {
      dispatch(initializePerson());
    }
    dispatch(initialize(formName, initialValues));
  },
  onSubmit: (params, data, redirect) => dispatch(registerPersonRequest({ params, data, redirect, formName })),
  onDelete: (params, redirect, initialized) => dispatch(deletePersonRequest({ params, redirect, initialized })),
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
  onOpenPersonGuide: (onSelected) => {
    dispatch(openPersonGuide(onSelected));
  },
  onOpenOrgGuide: (onSelected, orgGuideTargets) => {
    dispatch(setPersonOrgTargetRequest(orgGuideTargets));
    dispatch(openOrgGuide(onSelected));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(MntPersonForm);
