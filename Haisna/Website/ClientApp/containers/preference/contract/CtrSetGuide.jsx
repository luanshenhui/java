import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, getFormValues, reduxForm, FieldArray, blur } from 'redux-form';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import Button from '../../../components/control/Button';
import SectionBar from '../../../components/SectionBar';
import TextBox from '../../../components/control/TextBox';
import DropDownSetClass from '../../../components/control/dropdown/DropDownSetClass';
import DropDownCourse from '../../../components/control/dropdown/DropDownCourse';
import DropDownRsvFra from '../../../components/control/dropdown/DropDownRsvFra';
import GuideButton from '../../../components/GuideButton';
import Table from '../../../components/Table';
import DropDown from '../../../components/control/dropdown/DropDown';
import CheckBox from '../../../components/control/CheckBox';
import Label from '../../../components/control/Label';
import DropDownFreeValue from '../../../components/control/dropdown/DropDownFreeValue';
import GuideBase from '../../../components/common/GuideBase';
import ContractGuideHeader from './ContractGuideHeader';
import MessageBanner from '../../../components/MessageBanner';
import CtrSetGuidePrices from './CtrSetGuidePrices';
import * as Contants from '../../../constants/common';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../../components/Field';
import {
  closeCtrSetGuide,
  deleteOptionRequest,
  getSetGuideRequest,
  setAddOptionRequest,
  setDeleteOptionItemRequest,
  setAddOptionItemRequest,
  getCtrMngRequest,
} from '../../../modules/preference/contractModule';
import { actions as itemAndGroupGuideActions } from '../../../modules/common/itemAndGroupGuideModule';

const formName = 'CtrSetGuideForm';
// 性別
const genderItems = [{ value: 0, name: '男女共通' }, { value: 1, name: '男性' }, { value: 2, name: '女性' }];
// 追加条件
const addConditionItems = [{ value: 0, name: '上記条件に当てはまる場合、自動追加' }, { value: 1, name: '上記条件に当てはまる受診者が任意選択' }];

// 年齢編集
const OptionAges = ({ onSetAgeCheckValue }) => {
  const res = [];
  const ages = [];
  let cols = [];
  let num = 0;
  // 10行分編集
  for (let i = 1; i <= 10; i += 1) {
    cols = [];
    // 10列分編集
    for (let k = 1; k <= 10; k += 1) {
      cols.push(<td key={`tdages${num.toString()}`} ><Field component={CheckBox} name={`ages.age${num}`} checkedValue={num} label={`${num}歳`} /></td >);
      num += 1;
    }
    const check = { onOff: 1, strage: num - 10, endage: num - 1 };
    ages.push(<tr key={`trages${i.toString()}-${num.toString()}`}>{cols}<td key={`ages${num.toString()}`}><a role="presentation" onClick={() => onSetAgeCheckValue(check)}>←すべてチェックする</a></td></tr>);
  }
  const check = { onOff: 0, strage: 0, endage: 100 };
  const a = <a role="presentation" onClick={() => onSetAgeCheckValue(check)}>←すべてオフにする</a>;
  ages.push(<tr key="trages100-100"><td colSpan="2" key="ages100"><Field component={CheckBox} name="ages.age100" checkedValue={100} label="100歳以上" /></td><td colSpan="8">&nbsp;</td><td>{a}</td></tr>);
  res.push(<Table key="tbages"><tbody>{ages}</tbody></Table>);
  return res;
};

class CtrSetGuide extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleDeleteClick = this.handleDeleteClick.bind(this);
    this.handleCopyClick = this.handleCopyClick.bind(this);
    this.handleItemAddClick = this.handleItemAddClick.bind(this);
    this.handleItemDeleteClick = this.handleItemDeleteClick.bind(this);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { onLoad, match, visible } = this.props;
    if (!visible && nextProps.visible !== visible) {
      match.params.mode = nextProps.mode;
      match.params.optcd = nextProps.optcd;
      match.params.optbranchno = nextProps.optbranchno;

      onLoad(match.params);
    }
  }

  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  // 保存ボタン押下時の処理
  handleSubmit(values) {
    const { onSubmit, match, grpData, itemData } = this.props;
    const { params } = match;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この検査セットが変更されます。よろしいですか？')) {
      return;
    }
    onSubmit({ params, grpData, itemData, data: values });
  }

  // コピー"ボタン押下時の処理
  handleCopyClick() {
    const { onLoad, match } = this.props;
    const { params } = match;
    params.mode = Contants.MODE_COPY;
    onLoad(params);
  }

  // 削除ボタン押下時の処理
  handleDeleteClick() {
    const { onDelete, match } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この検査セットを削除します。よろしいですか？')) {
      return;
    }
    onDelete(match.params);
  }

  // 項目追加ボタン押下時の処理
  handleItemAddClick(values) {
    const { onItemAdd } = this.props;
    onItemAdd(values);
  }

  // 項目削除ボタン押下時の処理
  handleItemDeleteClick(values) {
    const { onItemDelete } = this.props;
    onItemDelete(values);
  }

  render() {
    const { handleSubmit, onClose, message, match, grpData, itemData, data, formValues, onSetAgeCheckValue, actions, mode } = this.props;
    const isUpdate = mode === 'UPD';

    return (
      <GuideBase {...this.props} title="検査セットの登録" usePagination={false}>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div>
            <Button onClick={onClose} value="キャンセル" />
            <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
            {isUpdate && <Button onClick={this.handleDeleteClick} value="削除" />}
            {isUpdate && <Button onClick={this.handleCopyClick} value="コピー" />}
          </div>
          <div style={{ overflow: 'auto', height: '800px' }}>
            <MessageBanner messages={message} />
            <ContractGuideHeader data={data} strong />
            <SectionBar title="基本情報" />
            <FieldGroup itemWidth={100}>
              <FieldSet>
                <FieldItem>セットコード</FieldItem>
                <FieldValueList>
                  <FieldValue key="set1">
                    <FieldSet>
                      {isUpdate ?
                        <Label>{match.params.optcd}-{match.params.optbranchno}</Label>
                        :
                        <FieldSet>
                          <Field name="option.optcd" component={TextBox} id="optcd" maxLength={Contants.LENGTH_OPTCD} style={{ width: 80 }} />
                          <Label>-</Label>
                          <Field name="option.optbranchno" component={TextBox} id="optbranchno" maxLength={2} style={{ width: 40 }} />
                        </FieldSet>
                      }
                      <Label>セット名：</Label>
                      <Field name="option.optname" component={TextBox} id="option.optname" maxLength={Contants.LENGTH_OPTNAME} style={{ width: 250 }} />
                      <Label>セット略称：</Label>
                      <Field name="option.optsname" component={TextBox} id="option.optsname" maxLength={Contants.LENGTH_OPTSNAME} style={{ width: 150 }} />
                      <Label>セットカラー：</Label>
                      <GuideButton onClick={() => { }} /><Label id="elemsetcolor">■</Label>
                    </FieldSet>
                  </FieldValue>
                  <FieldValue key="set2">
                    <FieldSet>
                      <Label> 管理コース：</Label>
                      <Field name="option.cscd" component={DropDownCourse} mode={2} />
                      <Label> セット分類：</Label>
                      <Field name="option.setclasscd" component={DropDownSetClass} addblank />
                      <Label> 管理対象となる予約枠：</Label>
                      <Field name="option.rsvfracd" component={DropDownRsvFra} addblank />
                    </FieldSet>
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
              <FieldSet>
                <FieldItem> 受診条件</FieldItem>
                <FieldValueList>
                  <FieldValue key="consult1">
                    <FieldSet>
                      <Label>受診区分：</Label>
                      <Field name="option.csldivcd" component={DropDownFreeValue} freecd="cslDiv" />
                    </FieldSet>
                  </FieldValue>
                  <FieldValue key="consult2">
                    <FieldSet>
                      <Label>性別：</Label>
                      <Field name="option.gender" component={DropDown} items={genderItems} selectedValue={0} />
                    </FieldSet>
                  </FieldValue>
                  <FieldValue key="consult3">
                    <FieldSet>
                      <Label>年齢：</Label>
                      <OptionAges onSetAgeCheckValue={onSetAgeCheckValue} />
                    </FieldSet>
                  </FieldValue>
                  <FieldValue key="consult4">
                    <FieldSet>
                      <Label>前回値：</Label>
                      <Label>過去</Label>
                      <Field name="option.lastrefmonth" component={TextBox} id="lastRefMonth" style={{ width: 40 }} />
                      <Label>ヶ月以内に</Label>
                      <Field name="option.lastrefcscd" component={DropDownCourse} mode={1} addblank />
                      <Label>を受診</Label>
                    </FieldSet>
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
              <FieldSet>
                <FieldItem>追加条件</FieldItem>
                <Field name="option.addcondition" component={DropDown} items={addConditionItems} selectedValue={0} />
              </FieldSet>
              <FieldSet>
                <FieldItem>非表示条件</FieldItem>
                <FieldValueList>
                  <FieldValue>
                    <Field component={CheckBox} name="option.hidersvfra" checkedValue={1} label="予約枠画面" />
                    <Field component={CheckBox} name="option.hidersv" checkedValue={1} label="予約画面" />
                    <Field component={CheckBox} name="option.hiderpt" checkedValue={1} label="受付画面" />
                    <Field component={CheckBox} name="option.hidequestion" checkedValue={1} label="問診画面" />
                  </FieldValue>
                  <FieldValue>
                    <span style={{ color: '#999999' }}>※チェックをつけた画面で、このセットは非表示になります。（セットグループの場合全てに反映されます）</span>
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
            </FieldGroup>
            <SectionBar title="請求情報" />
            <Field component={CheckBox} name="option.exceptlimit" checkedValue={1} label="このセットは限度額設定の対象としない" />
            <FieldArray {...this.props} name="orgprices" component={CtrSetGuidePrices} formName={formName} orgdata={data} formValues={formValues} />
            <SectionBar title="受診項目" />
            <div>
              <Button
                onClick={() => actions.itemAndGroupGuideOpenRequest({
                  itemMode: 1,
                  showGroup: true,
                  showItem: true,
                  onConfirm: (itemgrpdata) => this.handleItemAddClick(itemgrpdata),
                })}
                value="項目追加"
              />
              <Button onClick={handleSubmit((values) => this.handleItemDeleteClick(values))} value="項目削除" />
            </div>
            <FieldGroup>
              <FieldSet>
                <Field component="select" name="optionitems" size="12" style={{ width: 150, height: 180 }} multiple>
                  <option value="G0" key="G0">■検査グループ</option>
                  {grpData && grpData.map((rec) => (
                    <option value={rec.grpcd} key={rec.grpcd}>{rec.grpname} </option>
                  ))}
                  <option value="I0" key="I0">■検査項目</option>
                  {itemData && itemData.map((rec) => (
                    <option value={rec.itemcd} key={rec.itemcd}>{rec.requestname} </option>
                  ))}
                </Field>
              </FieldSet>
            </FieldGroup>
          </div >
        </form>
      </GuideBase>
    );
  }
}

const CtrSetGuideForm = reduxForm({
  form: formName,
})(CtrSetGuide);

CtrSetGuide.propTypes = {
  formValues: PropTypes.shape(),
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  reset: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  onItemAdd: PropTypes.func,
  onItemDelete: PropTypes.func,
  onClose: PropTypes.func.isRequired,
  onSetAgeCheckValue: PropTypes.func,
  data: PropTypes.shape().isRequired,
  grpData: PropTypes.arrayOf(PropTypes.shape()),
  itemData: PropTypes.arrayOf(PropTypes.shape()),
  orgprices: PropTypes.arrayOf(PropTypes.shape()),
  mode: PropTypes.string.isRequired,
  optcd: PropTypes.string.isRequired,
  optbranchno: PropTypes.string.isRequired,
  actions: PropTypes.shape(),
};

CtrSetGuide.defaultProps = {
  formValues: undefined,
  orgprices: [],
  onItemAdd: undefined,
  onItemDelete: undefined,
  onSetAgeCheckValue: undefined,
  grpData: [],
  itemData: [],
  actions: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: {
      option: {
        addcondition: 0,
        setcolor: '000000',
        optdiv: 0,
        gender: 0,
      },
      ptgroups: [],
      orgprices: [],
      ptitems: [],
      optionitems: [],
    },
    formValues,
    message: state.app.preference.contract.ctrSetGuide.message,
    visible: state.app.preference.contract.ctrSetGuide.visible,
    mode: state.app.preference.contract.ctrSetGuide.mode,
    optcd: state.app.preference.contract.ctrSetGuide.optcd,
    optbranchno: state.app.preference.contract.ctrSetGuide.optbranchno,
    grpData: state.app.preference.contract.ctrSetGuide.grpData,
    itemData: state.app.preference.contract.ctrSetGuide.itemData,
    data: state.app.preference.contract.contractGuideHeader.data,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 画面を初期化
    dispatch(getSetGuideRequest({ params, formName }));
    dispatch(getCtrMngRequest(params));
  },
  // 保存ボタン押下時の処理
  onSubmit: ({ params, grpData, itemData, data }) => {
    dispatch(setAddOptionRequest({ params, data: { ...data, ptgroups: grpData, ptitems: itemData } }));
  },
  // 削除ボタン押下時の処理
  onDelete: (params) => {
    dispatch(deleteOptionRequest(params));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeCtrSetGuide());
  },
  // 年齢チェックボックス制御
  onSetAgeCheckValue: (data) => {
    if (data === undefined) {
      return;
    }
    const { onOff, strage, endage } = data;
    for (let i = strage; i <= endage; i += 1) {
      const name = `ages.age${i}`;
      let val = null;
      if (onOff === 1) {
        val = i;
      }
      dispatch(blur(formName, name, val));
    }
  },
  // 負担金額と消費税計算
  onCalculate: (data) => {
    const { orgprices, taxrate } = data;
    const regExpString = '^[+-]?[0-9]+$';
    let totalPrice = 0;
    let totalTax = 0;

    for (let i = 0; i < orgprices.length; i += 1) {
      // 負担金額未入力であれば計算しない
      if (orgprices[i].price.toString().match(regExpString) !== null) {
        const price = Number.parseInt(orgprices[i].price, 10);
        if (totalPrice !== null) {
          totalPrice += price;
        }
        // 消費税が入力されていれば計算しない
        if (orgprices[i].tax === '' || orgprices[i].tax === null) {
          if (taxrate && taxrate !== null && !Number.isNaN(taxrate)) {
            // 消費税を計算する(端数は切り捨て)
            const calctax = Number.parseInt(price * Number.parseFloat(taxrate, 10), 10);
            dispatch(blur(formName, `orgprices[${i}].tax`, calctax));
            if (totalTax !== null) {
              totalTax += calctax;
            }
          }
        }
      } else {
        totalPrice = null;
      }
      if (orgprices[i].tax !== '' && orgprices[i].tax !== null) {
        // 消費税計算
        if (orgprices[i].tax.toString().match(regExpString) !== null) {
          const tax = Number.parseInt(orgprices[i].tax, 10);
          if (totalTax !== null) {
            totalTax += tax;
          }
        } else {
          totalTax = null;
        }
      }

    }
    dispatch(blur(formName, 'totalprice', totalPrice));
    dispatch(blur(formName, 'totaltax', totalTax));
  },
  // 検査項目の削除処理(固定見出しは非対象)
  onItemDelete: (data) => {
    const { optionitems } = data;
    dispatch(setDeleteOptionItemRequest(optionitems));
  },
  // 検査項目のADD処理(固定見出しは非対象)
  onItemAdd: (data) => {
    dispatch(setAddOptionItemRequest(data));
  },
  actions: bindActionCreators(itemAndGroupGuideActions, dispatch),
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CtrSetGuideForm));
