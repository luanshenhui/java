import React from 'react';
import PropTypes from 'prop-types';
import { Field, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import Table from '../../../components/Table';
import GuideButton from '../../../components/GuideButton';
import Button from '../../../components/control/Button';
import * as Constants from '../../../constants/common';
import OrgGuide from '../../../containers/common/OrgGuide';
import DropDownRowCount from '../../../components/control/dropdown/DropDownRowCount';
import Chip from '../../../components/Chip';
import {
  getRowCountRequest, selectedDemandRow, deleteDemandOrgGuide, closeDemandGuide } from '../../../modules/preference/contractModule';
import { openOrgGuide } from '../../../modules/preference/organizationModule';
import { FieldSet } from '../../../components/Field';
import LabelOrgName from '../../../components/control/label/LabelOrgName';

const formName = 'ctrCreateForm';

class CtrDemandBody extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedItem: '',
    };
    this.handleShowRowAddlClick = this.handleShowRowAddlClick.bind(this);
    this.onSelected = this.onSelected.bind(this);
  }
  onSelected = (data) => {
    this.setState({
      selectedItem: data,
    });
  }

  // 表示ボタンクリック時の処理
  handleShowRowAddlClick() {
    const { onShowRowAdd, formValues } = this.props;
    onShowRowAdd(formValues.rowCount);
  }

  render() {
    const { initialValues, onSelectOrg, onDeleteOrg, params } = this.props;

    const CtrOrgTable = () => {
      const res = [];

      // 負担元初期の表示行数
      for (let i = 0; i < initialValues.rowCount; i += 1) {
        const org = {};

        // 契約情報の更新の初期表示
        for (let j = 0; initialValues.ctrptorgpridedata && j < initialValues.ctrptorgpridedata.length && !initialValues.deleteflg && initialValues.selectedNowCount === null; j += 1) {
          if (initialValues.ctrptorgpridedata[j].apdiv === Constants.APDIV_PERSON && i === j) {
            initialValues.selectedContent[i] = initialValues.ctrptorgpridedata[j].orgname;
            initialValues.apdiv[i] = initialValues.ctrptorgpridedata[j].apdiv;
            initialValues.seq[i] = initialValues.ctrptorgpridedata[j].seq;
            initialValues.taxflg[i] = initialValues.ctrptorgpridedata[j].taxflg;
            initialValues.price[i] = initialValues.ctrptorgpridedata[j].price;
            initialValues.orgcd1[i] = initialValues.ctrptorgpridedata[j].orgcd1;
            initialValues.orgcd2[i] = initialValues.ctrptorgpridedata[j].orgcd2;
          } else if (initialValues.ctrptorgpridedata[j].apdiv === Constants.APDIV_MYORG && i === j) {
            initialValues.selectedContent[i] = <LabelOrgName orgcd1={params.orgcd1} orgcd2={params.orgcd2} />;
            initialValues.apdiv[i] = initialValues.ctrptorgpridedata[j].apdiv;
            initialValues.seq[i] = initialValues.ctrptorgpridedata[j].seq;
            initialValues.taxflg[i] = initialValues.ctrptorgpridedata[j].taxflg;
            initialValues.price[i] = initialValues.ctrptorgpridedata[j].price;
            initialValues.orgcd1[i] = initialValues.ctrptorgpridedata[j].orgcd1;
            initialValues.orgcd2[i] = initialValues.ctrptorgpridedata[j].orgcd2;
          } else if (i === j) {
            initialValues.selectedContent[i] = initialValues.ctrptorgpridedata[j].orgname;
            initialValues.apdiv[i] = initialValues.ctrptorgpridedata[j].apdiv;
            initialValues.seq[i] = initialValues.ctrptorgpridedata[j].seq;
            initialValues.taxflg[i] = initialValues.ctrptorgpridedata[j].taxflg;
            initialValues.price[i] = initialValues.ctrptorgpridedata[j].price;
            initialValues.orgcd1[i] = initialValues.ctrptorgpridedata[j].orgcd1;
            initialValues.orgcd2[i] = initialValues.ctrptorgpridedata[j].orgcd2;
          }
          if (initialValues.ctrptorgpridedata[j].limitpriceflg !== null && i === j) {
            initialValues.strLimitPriceFlg[i] = '○';
          }
          if (initialValues.ctrptorgpridedata[j].optburden !== 0 && i === j) {
            initialValues.strOptBurden[i] = '○';
          }
        }

        if ((initialValues.selectedCount.length === 0 || initialValues.selectedCount[i] !== i)
          && initialValues.selectedCount.length !== 0) {
          initialValues.selectedCount.push(null);
          initialValues.selectedContent.push(null);
          initialValues.orgcd1.push(null);
          initialValues.orgcd2.push(null);
          // 行の内容を追加する
        } else {
          initialValues.selectedCount.push(i);
          if (initialValues.selectedNowCount === i && this.state.selectedItem) {
            initialValues.selectedContent[i] = this.state.selectedItem.org.orgname;
            initialValues.orgcd1[i] = this.state.selectedItem.org.orgcd1;
            initialValues.orgcd2[i] = this.state.selectedItem.org.orgcd2;
            initialValues.apdiv[i] = 2;
            initialValues.taxflg[i] = '0';
            if ((params.orgcd1 === Constants.ORGCD1_PERSON && params.orgcd2 === Constants.ORGCD1_PERSON) ||
              (params.orgcd1 === Constants.ORGCD1_WEB && params.orgcd2 === Constants.ORGCD2_WEB)) {
              initialValues.seq[i] = i + 2;
            } else {
              initialValues.seq[i] = i + 1;
            }
          }
        }
        // 行の内容を削除する
        if (initialValues.deleteflg && initialValues.selectedNowCount === i) {
          initialValues.selectedContent[i] = null;
          initialValues.orgcd1[i] = null;
          initialValues.orgcd2[i] = null;
          if (initialValues.ctrptorgpridedata.length === 0) {
            initialValues.apdiv[i] = null;
            initialValues.seq[i] = null;
            initialValues.taxflg[i] = null;
            initialValues.price[i] = null;
          }
        }
        if (initialValues.ctrptorgpridedata.length === 0) {
          // 個人受診・Web予約の場合
          if ((params.orgcd1 === Constants.ORGCD1_PERSON && params.orgcd2 === Constants.ORGCD2_PERSON) ||
            (params.orgcd1 === Constants.ORGCD1_WEB && params.orgcd2 === Constants.ORGCD2_WEB)) {
            initialValues.apdiv[0] = 1;
            initialValues.seq[0] = 2;
            initialValues.orgcd1[0] = '';
            initialValues.orgcd2[0] = '';
            initialValues.selectedContent[0] = '個人負担';
            initialValues.taxflg[0] = '0';
            initialValues.price[0] = '0';
            // 契約団体の場合
          } else {
            initialValues.apdiv[0] = 0;
            initialValues.seq[0] = 1;
            initialValues.orgcd1[0] = Constants.ORGCD1_PERSON;
            initialValues.orgcd2[0] = Constants.ORGCD2_PERSON;
            initialValues.selectedContent[0] = '個人負担';
            initialValues.taxflg[0] = '0';
            initialValues.price[0] = '0';
            initialValues.apdiv[1] = 1;
            initialValues.seq[1] = 2;
            initialValues.orgcd1[1] = '';
            initialValues.orgcd2[1] = '';
            initialValues.selectedContent[1] = <LabelOrgName orgcd1={params.orgcd1} orgcd2={params.orgcd2} />;
            initialValues.taxflg[1] = '0';
            initialValues.price[1] = '0';
          }
        }

        org.selectedCount = initialValues.selectedCount;
        org.selectedContent = initialValues.selectedContent;
        org.strOptBurden = initialValues.strOptBurden;
        org.strLimitPriceFlg = initialValues.strLimitPriceFlg;
        org.orgcd1 = initialValues.orgcd1;
        org.orgcd2 = initialValues.orgcd2;
        org.apdiv = initialValues.apdiv;
        org.seq = initialValues.seq;
        org.price = initialValues.price;
        org.taxflg = initialValues.taxflg;
        org.key = i;
        res.push(org);
      }
      return res;
    };

    return (
      <div>
        <div style={{ height: '460px', overflow: 'auto' }}>
          <Table>
            <thead>
              <tr>
                <td width="300" bgcolor="#cccccc">負担元</td>
                <td align="center" width="80">セット負担</td>
                <td align="center" width="80">限度額設定</td>
              </tr>
            </thead>
            <tbody>
              {CtrOrgTable(initialValues).map((rec, index) => (
                <tr key={rec.key}>
                  <td>
                    <FieldSet>
                      <OrgGuide />
                      {(rec.apdiv[index] === Constants.APDIV_ORG || rec.apdiv[index] == null) && (
                        <GuideButton
                          onClick={() => {
                            onSelectOrg(index, rec.selectedCount, this.onSelected);
                          }}
                        />
                      )}
                      {rec.apdiv[index] !== Constants.APDIV_ORG && rec.selectedContent[index] !== null && (
                        <Chip label={rec.selectedContent[index]} />
                      )}
                      {(rec.apdiv[index] === Constants.APDIV_ORG && rec.apdiv[index] !== null) && (
                        <Chip
                          label={rec.selectedContent[index]}
                          onDelete={() => {
                            onDeleteOrg(index);
                          }}
                        />
                      )}
                    </FieldSet>
                  </td>
                  <td style={{ textAlign: 'center' }} >{rec.strOptBurden[index]}</td>
                  <td style={{ textAlign: 'center' }} >{rec.strLimitPriceFlg[index]}</td>
                </tr>
              ))}
            </tbody>
          </Table>
        </div>
        <div>負担元の入力行数を指定：
          <Field name="rowCount" component={DropDownRowCount} itemsRows={10} id="rowCount" selectedValue="15" />
          <Button onClick={this.handleShowRowAddlClick} value="表示" />
        </div>
      </div>
    );
  }
}

CtrDemandBody.defaultProps = {
  params: {},
};

// propTypesの定義
CtrDemandBody.propTypes = {
  onSelectOrg: PropTypes.func.isRequired,
  onDeleteOrg: PropTypes.func.isRequired,
  onShowRowAdd: PropTypes.func.isRequired,
  formValues: PropTypes.shape().isRequired,
  initialValues: PropTypes.shape().isRequired,
  params: PropTypes.shape(),
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      ctrptorgpridedata: state.app.preference.contract.ctrDemandGuide.ctrptorgpridedata,
      rowCount: state.app.preference.contract.ctrDemandGuide.rowCount,
      selectedCount: state.app.preference.contract.ctrDemandGuide.selectedCount,
      selectedContent: state.app.preference.contract.ctrDemandGuide.selectedContent,
      selectedNowCount: state.app.preference.contract.ctrDemandGuide.selectedNowCount,
      apdiv: state.app.preference.contract.ctrDemandGuide.apdiv,
      strOptBurden: state.app.preference.contract.ctrDemandGuide.strOptBurden,
      strLimitPriceFlg: state.app.preference.contract.ctrDemandGuide.strLimitPriceFlg,
      orgcd1: state.app.preference.contract.ctrDemandGuide.orgcd1,
      orgcd2: state.app.preference.contract.ctrDemandGuide.orgcd2,
      seq: state.app.preference.contract.ctrDemandGuide.seq,
      price: state.app.preference.contract.ctrDemandGuide.price,
      taxflg: state.app.preference.contract.ctrDemandGuide.taxflg,
      deleteflg: state.app.preference.contract.ctrDemandGuide.deleteflg,
    },
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeDemandGuide());
  },
  // 表示ボタン押下時の処理
  onShowRowAdd: (params) => {
    const rowCount = params;
    dispatch(getRowCountRequest({ rowCount }));
  },
  // 团体選択の処理
  onSelectOrg: (index, rec, onSelected) => {
    const params = {};
    const array = rec;
    for (let i = 0; i < rec.length; i += 1) {
      if (i === index) {
        array[i] = index;
      }
    }
    params.selectedCount = array;
    params.selectedNowCount = index;
    dispatch(selectedDemandRow(params));
    dispatch(openOrgGuide({ onSelected }));
  },
  // 選択团体削除の処理
  onDeleteOrg: (index) => {
    const params = {};
    params.selectedNowCount = index;
    dispatch(deleteDemandOrgGuide(params));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CtrDemandBody));
