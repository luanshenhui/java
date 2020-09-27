/**
 * @file 抽出データの指定
 */
import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { Field, reduxForm, formValueSelector } from 'redux-form';
import moment from 'moment';
import PropTypes from 'prop-types';

// 共通コンポーネント
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import DatePicker from '../../components/control/datepicker/DatePicker';
import Radio from '../../components/control/Radio';
import CheckBox from '../../components/control/CheckBox';
import SectionBar from '../../components/SectionBar';
import DropDown from '../../components/control/dropdown/DropDown';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import DropDownGender from '../../components/control/dropdown/DropDownGender';
import DropDownJud from '../../components/control/dropdown/DropDownJud';
import ReportOrgParameter from '../report/ReportOrgParameter';
import Button from '../../components/control/Button';
import TextBox from '../../components/control/TextBox';
import DropDownJudClass from '../../components/control/dropdown/DropDownJudClass';
import { actions as itemAndGroupGuideActions } from '../../modules/common/itemAndGroupGuideModule';
import GuideButton from '../../components/GuideButton';
import Chip from '../../components/Chip';

// ページタイトル
const TITLE = '抽出データの指定';

// 年齢年ドロップダウンアイテム
const ageYItems = Array.from({ length: 151 }, (_, i) => ({ name: i, value: i }));
// 年齢月ドロップダウンアイテム
const ageMItems = Array.from({ length: 12 }, (_, i) => ({ name: i, value: i }));

// フォーム名
const formName = 'AbsenceListNttDataForm';

const iniDispItem = [];
for (let i = 0; i < 50; i += 1) {
  iniDispItem.push({ itemCd: '', itemName: '' });
}
const iniConItem = [];
for (let i = 0; i < 50; i += 1) {
  iniConItem.push({ itemCd: '', itemName: '' });
}

// 初期値の設定
const initialValues = {
  // 開始受診日
  startdate: moment().format('YYYY/MM/DD'),
  // 終了受診日
  enddate: moment().format('YYYY/MM/DD'),
  // 開始年齢年
  startagey: 0,
  // 終了年齢年
  endagey: 150,
  // ファイル名
  fileName: 'datCslList.csv',
  // CSVの値をダブルクォーテーションで囲まない
  addQuotes: 0,
  // ヘッダを付加しない
  noHeader: 1,

  optresult: 1,
  judall: 0,
  judoperation: 0,

  itemdispnum: 2,
  dispCount: 2,
  itemconditionnum: 10,
  conditionCount: 10,
  judonditionnum: 5,
  judCount: 5,

  dispItem: iniDispItem,
  conItem: iniConItem,
};

// 抽出対象項目
const ItemDispNum = [
  { name: '10個', value: 2 },
  { name: '20個', value: 4 },
  { name: '30個', value: 6 },
  { name: '40個', value: 8 },
  { name: '50個', value: 10 },
];

// 項目条件
const ItemConditionNum = [
  { name: '10個', value: 10 },
  { name: '20個', value: 20 },
  { name: '30個', value: 30 },
  { name: '40個', value: 40 },
  { name: '50個', value: 50 },
];

// 判定条件
const JudConditionNum = [
  { name: '5個', value: 5 },
  { name: '10個', value: 10 },
  { name: '15個', value: 15 },
  { name: '20個', value: 20 },
];

// 判定条件
const ValueSuffix = [
  { name: 'と同じ', value: 1 },
  { name: '以上', value: 2 },
  { name: '以下', value: 3 },
];

// 抽出データの指定レイアウト
const CsvDatConsult = (props) => {
  // すでに検査項目が選択されていた場合Trueを返す関数
  const ExistJudge = (data, value) => {
    for (let i = 0; i < data.length; i += 1) {
      if (data[i].itemCd === value) { return true; }
    }
    return false;
  };

  // 抽出対象メイン
  const ItemDisp = [];
  for (let i = 0; i < parseInt(props.dispCount, 10); i += 1) {
    ItemDisp.push((
      <tr>
        <td>
          <div style={{ display: 'flex' }}>
            <GuideButton
              onClick={() => props.actions.itemAndGroupGuideOpenRequest({
                itemMode: 2,
                showGroup: false,
                showItem: true,
                onConfirm: (data) => {
                  // propsから現在の状態を取得
                  const tempDispItem = props.dispItem;
                  const tempConItem = props.conItem;
                  let errorItem = '';
                  for (let j = 0; j < data.length; j += 1) {
                    // 画面表示数を超える場合は追加しない
                    if ((i * 5) + j < parseInt(props.dispCount, 10) * 5) {
                      // 選択済みの項目は追加しない
                      if (ExistJudge(tempDispItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                        tempDispItem[(i * 5) + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                        tempDispItem[(i * 5) + j].itemName = data[j].itemName;
                        // 抽出する項目を指定する場合、検査項目条件にも同じ検査項目を追加する
                        if (props.optresult === 3) {
                          // 画面表示数を超える場合は追加しない
                          if ((i * 5) + j < parseInt(props.conditionCount, 10)) {
                            // 選択済みの項目は追加しない
                            if (ExistJudge(tempConItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                              tempConItem[(i * 5) + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                              tempConItem[(i * 5) + j].itemName = data[j].itemName;
                            }
                          }
                        }
                      } else {
                        if (errorItem) {
                          errorItem += '\n';
                        }
                        errorItem += data[j].itemName;
                      }
                    }
                  }
                  if (errorItem) {
                    alert(`以下の項目が重複しています。\n${errorItem}`);
                  }
                  // propsへ反映
                  props.change('dispItem', tempDispItem);
                  // 抽出する項目を指定する場合、検査項目条件にも同じ検査項目を追加する
                  if (props.optresult === 3) {
                    props.change('conItem', tempConItem);
                  }
                  props.change('dummy', `item1${i}`);
                },
              })}
            />
            { props.dispItem[(i * 5)].itemCd && <Chip
              name={`itemName${(i * 5)}`}
              label={props.dispItem[(i * 5)].itemName}
              onDelete={() => {
                const tempDispItem = props.dispItem;
                tempDispItem[(i * 5)].itemCd = '';
                tempDispItem[(i * 5)].itemName = '';
                props.change('dispItem', tempDispItem);
                props.change('dummy', `delitem1${i}`);
              }}
            />}
          </div>
        </td>
        <td>
          <div style={{ display: 'flex' }}>
            <GuideButton
              onClick={() => props.actions.itemAndGroupGuideOpenRequest({
                itemMode: 2,
                showGroup: false,
                showItem: true,
                onConfirm: (data) => {
                  // propsから現在の状態を取得
                  const tempDispItem = props.dispItem;
                  const tempConItem = props.conItem;
                  let errorItem = '';
                  for (let j = 0; j < data.length; j += 1) {
                    // 画面表示数を超える場合は追加しない
                    if ((i * 5) + j + 1 < parseInt(props.dispCount, 10) * 5) {
                      // 選択済みの項目は追加しない
                      if (ExistJudge(tempDispItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                        tempDispItem[(i * 5) + 1 + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                        tempDispItem[(i * 5) + 1 + j].itemName = data[j].itemName;
                        // 抽出する項目を指定する場合、検査項目条件にも同じ検査項目を追加する
                        if (props.optresult === 3) {
                          // 画面表示数を超える場合は追加しない
                          if ((i * 5) + 1 + j < parseInt(props.conditionCount, 10)) {
                            // 選択済みの項目は追加しない
                            if (ExistJudge(tempConItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                              tempConItem[(i * 5) + 1 + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                              tempConItem[(i * 5) + 1 + j].itemName = data[j].itemName;
                            }
                          }
                        }
                      } else {
                        if (errorItem) {
                          errorItem += '\n';
                        }
                        errorItem += data[j].itemName;
                      }
                    }
                  }
                  if (errorItem) {
                    alert(`以下の項目が重複しています。\n${errorItem}`);
                  }
                  // propsへ反映
                  props.change('dispItem', tempDispItem);
                  // 抽出する項目を指定する場合、検査項目条件にも同じ検査項目を追加する
                  if (props.optresult === 3) {
                    props.change('conItem', tempConItem);
                  }
                  props.change('dummy', `item2${i + 1}`);
                },
              })}
            />
            { props.dispItem[(i * 5) + 1].itemCd && <Chip
              name={`itemName${(i * 5) + 1}`}
              label={props.dispItem[(i * 5) + 1].itemName}
              onDelete={() => {
                const tempDispItem = props.dispItem;
                tempDispItem[(i * 5) + 1].itemCd = '';
                tempDispItem[(i * 5) + 1].itemName = '';
                props.change('dispItem', tempDispItem);
                props.change('dummy', `delitem2${i + 1}`);
              }}
            />}
          </div>
        </td>
        <td>
          <div style={{ display: 'flex' }}>
            <GuideButton
              onClick={() => props.actions.itemAndGroupGuideOpenRequest({
                itemMode: 2,
                showGroup: false,
                showItem: true,
                onConfirm: (data) => {
                  // propsから現在の状態を取得
                  const tempDispItem = props.dispItem;
                  const tempConItem = props.conItem;
                  let errorItem = '';
                  for (let j = 0; j < data.length; j += 1) {
                    // 画面表示数を超える場合は追加しない
                    if ((i * 5) + j + 2 < parseInt(props.dispCount, 10) * 5) {
                      // 選択済みの項目は追加しない
                      if (ExistJudge(tempDispItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                        tempDispItem[(i * 5) + 2 + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                        tempDispItem[(i * 5) + 2 + j].itemName = data[j].itemName;
                        // 抽出する項目を指定する場合、検査項目条件にも同じ検査項目を追加する
                        if (props.optresult === 3) {
                          // 画面表示数を超える場合は追加しない
                          if ((i * 5) + 2 + j < parseInt(props.conditionCount, 10)) {
                            // 選択済みの項目は追加しない
                            if (ExistJudge(tempConItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                              tempConItem[(i * 5) + 2 + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                              tempConItem[(i * 5) + 2 + j].itemName = data[j].itemName;
                            }
                          }
                        }
                      } else {
                        if (errorItem) {
                          errorItem += '\n';
                        }
                        errorItem += data[j].itemName;
                      }
                    }
                  }
                  if (errorItem) {
                    alert(`以下の項目が重複しています。\n${errorItem}`);
                  }
                  // propsへ反映
                  props.change('dispItem', tempDispItem);
                  // 抽出する項目を指定する場合、検査項目条件にも同じ検査項目を追加する
                  if (props.optresult === 3) {
                    props.change('conItem', tempConItem);
                  }
                  props.change('dummy', `item3${i + 2}`);
                },
              })}
            />
            { props.dispItem[(i * 5) + 2].itemCd && <Chip
              name={`itemName${(i * 5) + 2}`}
              label={props.dispItem[(i * 5) + 2].itemName}
              onDelete={() => {
                const tempDispItem = props.dispItem;
                tempDispItem[(i * 5) + 2].itemCd = '';
                tempDispItem[(i * 5) + 2].itemName = '';
                props.change('dispItem', tempDispItem);
                props.change('dummy', `delitem3${i + 2}`);
              }}
            />}
          </div>
        </td>
        <td>
          <div style={{ display: 'flex' }}>
            <GuideButton
              onClick={() => props.actions.itemAndGroupGuideOpenRequest({
                itemMode: 2,
                showGroup: false,
                showItem: true,
                onConfirm: (data) => {
                  // propsから現在の状態を取得
                  const tempDispItem = props.dispItem;
                  const tempConItem = props.conItem;
                  let errorItem = '';
                  for (let j = 0; j < data.length; j += 1) {
                    // 画面表示数を超える場合は追加しない
                    if ((i * 5) + j + 3 < parseInt(props.dispCount, 10) * 5) {
                      // 選択済みの項目は追加しない
                      if (ExistJudge(tempDispItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                        tempDispItem[(i * 5) + 3 + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                        tempDispItem[(i * 5) + 3 + j].itemName = data[j].itemName;
                        // 抽出する項目を指定する場合、検査項目条件にも同じ検査項目を追加する
                        if (props.optresult === 3) {
                          // 画面表示数を超える場合は追加しない
                          if ((i * 5) + 3 + j < parseInt(props.conditionCount, 10)) {
                            // 選択済みの項目は追加しない
                            if (ExistJudge(tempConItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                              tempConItem[(i * 5) + 3 + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                              tempConItem[(i * 5) + 3 + j].itemName = data[j].itemName;
                            }
                          }
                        }
                      } else {
                        if (errorItem) {
                          errorItem += '\n';
                        }
                        errorItem += data[j].itemName;
                      }
                    }
                  }
                  if (errorItem) {
                    alert(`以下の項目が重複しています。\n${errorItem}`);
                  }
                  // propsへ反映
                  props.change('dispItem', tempDispItem);
                  // 抽出する項目を指定する場合、検査項目条件にも同じ検査項目を追加する
                  if (props.optresult === 3) {
                    props.change('conItem', tempConItem);
                  }
                  props.change('dummy', `item4${i + 3}`);
                },
              })}
            />
            { props.dispItem[(i * 5) + 3].itemCd && <Chip
              name={`itemName${(i * 5) + 3}`}
              label={props.dispItem[(i * 5) + 3].itemName}
              onDelete={() => {
                const tempDispItem = props.dispItem;
                tempDispItem[(i * 5) + 3].itemCd = '';
                tempDispItem[(i * 5) + 3].itemName = '';
                props.change('dispItem', tempDispItem);
                props.change('dummy', `delitem4${i + 3}`);
              }}
            />}
          </div>
        </td>
        <td>
          <div style={{ display: 'flex' }}>
            <GuideButton
              onClick={() => props.actions.itemAndGroupGuideOpenRequest({
                itemMode: 2,
                showGroup: false,
                showItem: true,
                onConfirm: (data) => {
                  // propsから現在の状態を取得
                  const tempDispItem = props.dispItem;
                  const tempConItem = props.conItem;
                  let errorItem = '';
                  for (let j = 0; j < data.length; j += 1) {
                    // 画面表示数を超える場合は追加しない
                    if ((i * 5) + j + 4 < parseInt(props.dispCount, 10) * 5) {
                      // 選択済みの項目は追加しない
                      if (ExistJudge(tempDispItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                        tempDispItem[(i * 5) + 4 + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                        tempDispItem[(i * 5) + 4 + j].itemName = data[j].itemName;
                        // 抽出する項目を指定する場合、検査項目条件にも同じ検査項目を追加する
                        if (props.optresult === 3) {
                          // 画面表示数を超える場合は追加しない
                          if ((i * 5) + 4 + j < parseInt(props.conditionCount, 10)) {
                            // 選択済みの項目は追加しない
                            if (ExistJudge(tempConItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                              tempConItem[(i * 5) + 4 + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                              tempConItem[(i * 5) + 4 + j].itemName = data[j].itemName;
                            }
                          }
                        }
                      } else {
                        if (errorItem) {
                          errorItem += '\n';
                        }
                        errorItem += data[j].itemName;
                      }
                    }
                  }
                  if (errorItem) {
                    alert(`以下の項目が重複しています。\n${errorItem}`);
                  }
                  // propsへ反映
                  props.change('dispItem', tempDispItem);
                  // 抽出する項目を指定する場合、検査項目条件にも同じ検査項目を追加する
                  if (props.optresult === 3) {
                    props.change('conItem', tempConItem);
                  }
                  props.change('dummy', `item5${i + 4}`);
                },
              })}
            />
            { props.dispItem[(i * 5) + 4].itemCd && <Chip
              name={`itemName${(i * 5) + 4}`}
              label={props.dispItem[(i * 5) + 4].itemName}
              onDelete={() => {
                const tempDispItem = props.dispItem;
                tempDispItem[(i * 5) + 4].itemCd = '';
                tempDispItem[(i * 5) + 4].itemName = '';
                props.change('dispItem', tempDispItem);
                props.change('dummy', `delitem5${i + 4}`);
              }}
            />}
          </div>
        </td>
      </tr>
    ));
  }

  // 抽出対象項目で表示しない項目をクリアする関数
  const DispItemClear = (num) => {
    // propsから現在の状態を取得
    const tempDispItem = props.dispItem;
    for (let i = parseInt(num, 10); i < 10; i += 1) {
      tempDispItem[(i * 5)].itemCd = '';
      tempDispItem[(i * 5) + 1].itemCd = '';
      tempDispItem[(i * 5) + 2].itemCd = '';
      tempDispItem[(i * 5) + 3].itemCd = '';
      tempDispItem[(i * 5) + 4].itemCd = '';
      tempDispItem[(i * 5)].itemName = '';
      tempDispItem[(i * 5) + 1].itemName = '';
      tempDispItem[(i * 5) + 2].itemName = '';
      tempDispItem[(i * 5) + 3].itemName = '';
      tempDispItem[(i * 5) + 4].itemName = '';
    }
    // propsに反映
    props.change('dispItem', tempDispItem);
  };

  // 抽出条件検査項目
  const ItemCondition = [];
  for (let i = 0; i < parseInt(props.conditionCount, 10); i += 1) {
    ItemCondition.push((
      <tr>
        <td style={{ width: 170 }} >
          <div style={{ display: 'flex' }}>
            <GuideButton
              onClick={() => props.actions.itemAndGroupGuideOpenRequest({
                itemMode: 2,
                showGroup: false,
                showItem: true,
                onConfirm: (data) => {
                  // propsから現在の状態を取得
                  const tempConItem = props.conItem;
                  let errorItem = '';
                  for (let j = 0; j < data.length; j += 1) {
                    // 画面表示数を超える場合は追加しない
                    if (i + j < parseInt(props.conditionCount, 10)) {
                      // 選択済みの項目は追加しない
                      if (ExistJudge(tempConItem, `${data[j].itemCd}|${data[j].suffix}`) === false) {
                        tempConItem[i + j].itemCd = `${data[j].itemCd}|${data[j].suffix}`;
                        tempConItem[i + j].itemName = data[j].itemName;
                      } else {
                        if (errorItem) {
                          errorItem += '\n';
                        }
                        errorItem += data[j].itemName;
                      }
                    }
                  }
                  if (errorItem) {
                    alert(`以下の項目が重複しています。\n${errorItem}`);
                  }
                  // propsへ反映
                  props.change('conItem', tempConItem);
                  props.change('dummy', `conItem${i}`);
                },
              })}
            />
            { props.conItem[i].itemCd && <Chip
              name={`conItemName${i}`}
              label={props.conItem[i].itemName}
              onDelete={() => {
                const tempConItem = props.conItem;
                tempConItem[i].itemCd = '';
                tempConItem[i].itemName = '';
                props.change('conItem', tempConItem);
                props.change('dummy', `delconItem${i}`);
              }}
            />}
          </div>
        </td>
        <td style={{ display: 'flex' }}>
          の検査結果が
          <Field name={`convalue1_${i}`} component={TextBox} style={{ width: 90 }} />
          <div style={{ paddingLeft: 5 }} >
            <Field name={`consuffix1_${i}`} component={DropDown} items={ValueSuffix} addblank />
          </div>
          ～
          <Field name={`convalue2_${i}`} component={TextBox} style={{ width: 90 }} />
          <div style={{ paddingLeft: 5 }} >
            <Field name={`consuffix2_${i}`} component={DropDown} items={ValueSuffix} addblank />
          </div>
        </td>
      </tr>
    ));
  }

  // 抽出条件項目で表示しない項目をクリアする関数
  const ConItemClear = (num) => {
    // propsから現在の状態を取得
    const tempConItem = props.conItem;
    for (let i = parseInt(num, 10); i < 50; i += 1) {
      tempConItem[i].itemCd = '';
      tempConItem[i].itemName = '';
    }
    // propsに反映
    props.change('conItem', tempConItem);
  };

  // 抽出条件判定
  const JudCondition = [];
  for (let i = 0; i < parseInt(props.judCount, 10); i += 1) {
    JudCondition.push((
      <div>
        <Field name={`judclass_${i}`} component={DropDownJudClass} addblank />
        の判定結果が
        <Field name={`judvalue1_${i}`} component={DropDownJud} addblank />
        <Field name={`judsuffix1_${i}`} component={DropDown} items={ValueSuffix} addblank />
        ～
        <Field name={`judvalue2_${i}`} component={DropDownJud} addblank />
        <Field name={`judsuffix2_${i}`} component={DropDown} items={ValueSuffix} addblank />
      </div>
    ));
  }

  return (
    <div>
      <Field name="dummy" component={TextBox} style={{ width: 1000 }} type="hidden" />
      <SectionBar title="受診歴情報" />
      <div style={{ paddingLeft: 5 }}>
        <Field name="csldate" component={CheckBox} label="受診日" checkedValue={1} />
        <Field name="course" component={CheckBox} label="コース" checkedValue={1} />
        <Field name="age" component={CheckBox} label="受診時年齢" checkedValue={1} />
        <Field name="jud" component={CheckBox} label="総合判定" checkedValue={1} />
      </div>
      <SectionBar title="個人情報" />
      <div style={{ paddingLeft: 5 }}>
        <Field name="perid" component={CheckBox} label="個人ID" checkedValue={1} />
        <Field name="name" component={CheckBox} label="氏名" checkedValue={1} />
        <Field name="birth" component={CheckBox} label="生年月日" checkedValue={1} />
        <Field name="chkgender" component={CheckBox} label="性別" checkedValue={1} />
      </div>
      <SectionBar title="検査項目" />
      <div style={{ paddingLeft: 5 }}>
        <Field name="optresult" component={Radio} label="検査結果を抽出しない" checkedValue={1} />
        <Field name="optresult" component={Radio} label="すべての検査結果を抽出する" checkedValue={2} />
        <Field name="optresult" component={Radio} label="抽出する項目を指定する" checkedValue={3} />
      </div>
      <table border="0" cellPadding="0" cellSpacing="2">
        <tbody>
          <tr>
            <th style={{ width: 170 }} ><SectionBar title="検査項目" /></th>
            <th style={{ width: 170 }} ><SectionBar title="検査項目" /></th>
            <th style={{ width: 170 }} ><SectionBar title="検査項目" /></th>
            <th style={{ width: 170 }} ><SectionBar title="検査項目" /></th>
            <th style={{ width: 170 }} ><SectionBar title="検査項目" /></th>
          </tr>
          {ItemDisp}
        </tbody>
      </table>
      <Field name="cmtflg" component={CheckBox} label="結果コメント・正常値フラグを抽出データに含む" checkedValue={1} />
      <div>
        追加検査項目を
        <Field
          name="itemdispnum"
          component={DropDown}
          items={ItemDispNum}
        />
        <Button
          value="表示"
          onClick={() => {
              DispItemClear(props.itemdispnum);
              props.change('dispCount', props.itemdispnum);
            }
          }
        />
        <Field name="dispCount" component="input" type="hidden" />
      </div>
      <SectionBar title="受診歴条件" />
      <ReportParameter label="受診日" isRequired>
        <Field name="startdate" component={DatePicker} />
        <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>～</div>
        <Field name="enddate" component={DatePicker} />
      </ReportParameter>
      <ReportParameter label="コース">
        <Field component={DropDownCourse} name="cscd" addblank blankname="すべて" />
      </ReportParameter>
      <ReportParameter label="団体">
        <ReportOrgParameter {...props} formName={formName} orgCd1Field="orgcd1" orgCd2Field="orgcd2" orgNameField="orgName" />
      </ReportParameter>
      <ReportParameter label="受診時年齢">
        <Field component={DropDown} name="startagey" items={ageYItems} addblank /><span>.</span>
        <Field component={DropDown} name="startagem" items={ageMItems} addblank />
        <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>歳以上</div>
        <Field component={DropDown} name="endagey" items={ageYItems} addblank /><span>.</span>
        <Field component={DropDown} name="endagem" items={ageMItems} addblank />
        <div style={{ marginLeft: '10px', marginRight: '10px', marginTop: 'auto', marginBottom: 'auto' }}>歳以下</div>
      </ReportParameter>
      <ReportParameter label="性別">
        <Field component={DropDownGender} name="gender" addblank blankname="男女" />
      </ReportParameter>
      <SectionBar title="検査項目" />
      {ItemCondition}
      <div>
        追加検査項目を
        <Field
          name="itemconditionnum"
          component={DropDown}
          items={ItemConditionNum}
        />
        <Button
          value="表示"
          onClick={() => {
              ConItemClear(props.itemconditionnum);
              props.change('conditionCount', props.itemconditionnum);
            }
          }
        />
        <Field name="conditionCount" component="input" type="hidden" />
      </div>
      <SectionBar title="総合判定" />
      <div>
        <Field name="judall" component={Radio} label="すべての判定分類を抽出" checkedValue={0} />
        <Field name="judall" component={Radio} label="以下の条件を満たす判定分類のみを抽出" checkedValue={1} />
      </div>
      {JudCondition}
      <div>
        <Field name="judoperation" component={Radio} label="AND" checkedValue={0} />
        <Field name="judoperation" component={Radio} label="OR" checkedValue={1} />
      </div>
      <div>
        追加分野を
        <Field
          name="judconditionnum"
          component={DropDown}
          items={JudConditionNum}
        />
        <Button
          value="表示"
          onClick={() => props.change('judCount', props.judconditionnum)}
        />
        <Field name="judCount" component="input" type="hidden" />
      </div>
    </div>
  );
};

CsvDatConsult.propTypes = {
  itemdispnum: PropTypes.string,
  dispCount: PropTypes.number,
  itemconditionnum: PropTypes.string,
  conditionCount: PropTypes.number,
  judconditionnum: PropTypes.string,
  judCount: PropTypes.number,
  change: PropTypes.func.isRequired,
  actions: PropTypes.shape().isRequired,
  setSelectedItem: PropTypes.func.isRequired,
  dispItem: PropTypes.shape({
    itemCd: PropTypes.string,
    itemName: PropTypes.string,
  }),
  conItem: PropTypes.shape({
    itemCd: PropTypes.string,
    itemName: PropTypes.string,
  }),
  dummy: PropTypes.string,
  optresult: PropTypes.number,
};

CsvDatConsult.defaultProps = {
  itemdispnum: undefined,
  dispCount: undefined,
  itemconditionnum: undefined,
  conditionCount: undefined,
  judconditionnum: undefined,
  judCount: undefined,
  dispItem: iniDispItem,
  conItem: iniConItem,
  dummy: undefined,
  optresult: 1,
};

// redux-formでstate管理するようにする
const CsvDatConsultForm = reduxForm({
  form: formName,
  initialValues,
})(ReportForm(CsvDatConsult, TITLE, 'csvdatconsult'));

const selector = formValueSelector(formName);

export default connect(
  (state) => {
    const { itemdispnum, dispCount, itemconditionnum, conditionCount, judconditionnum, judCount,
      dispItem, conItem, dummy, optresult,
    }
    = selector(
      state, 'itemdispnum', 'dispCount', 'itemconditionnum', 'conditionCount', 'judconditionnum', 'judCount',
      'dispItem', 'conItem', 'dummy', 'optresult',
    );
    return {
      itemdispnum,
      dispCount,
      itemconditionnum,
      conditionCount,
      judconditionnum,
      judCount,
      dispItem,
      conItem,
      dummy,
      optresult,
    };
  },
  (dispatch) => ({
    actions: bindActionCreators(itemAndGroupGuideActions, dispatch),
  }),
)(CsvDatConsultForm);
