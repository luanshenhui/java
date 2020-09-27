import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import Table from '../../../components/Table';
import MessageBanner from '../../../components/MessageBanner';
import * as Constants from '../../../constants/common';
import { openCtrSetGuide } from '../../../modules/preference/contractModule';

// 検査セットヘッダの編集
const PatternPriceOptsTableHeader = ({ data }) => {
  const res = [];
  for (let i = 0; i < data.length; i += 1) {
    res.push(<th key={`thprice${i.toString()}`}>負担金額</th>);
    res.push(<th key={`thtax${i.toString()}`}>消費税</th>);
  }
  return res;
};

// 検査セットボディの編集
const PatternPriceOptsTableBody = ({ data, onOpenCtrSetGuide }) => {
  const res = [];
  const { count, optcd, optbranchno, setcolor, optname, csldivname, gender, agename, addcondition, exceptlimit, price, tax } = data;
  for (let i = 0; i < count; i += 1) {
    addcondition[i] = addcondition[i] === 1 ? '任意' : ' ';
    if (gender[i] === 1) {
      gender[i] = '男性';
    } else if (gender[i] === 2) {
      gender[i] = '女性';
    } else {
      gender[i] = ' ';
    }

    const tdPriceTax = [];
    let totPrice = 0;
    let totTax = 0;
    for (let k = 0; k < price.length; k += 1) {
      tdPriceTax.push(<td align="right" key={`tdprice${(i + k).toString()}`}>&#165;{price[k][i].toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>);
      tdPriceTax.push(<td align="right" key={`tdtax${(i + k).toString()}`}>&#165;{tax[k][i].toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>);
      totPrice += price[k][i];
      totTax += tax[k][i];
    }
    tdPriceTax.push(<td align="right" bgcolor="#EFF3FF" key={`totprice${i.toString()}`}>&#165;{totPrice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>);
    tdPriceTax.push(<td align="right" bgcolor="#EFF3FF" key={`tottax${i.toString()}`}>&#165;{totTax.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>);

    const tdSet = [];
    tdSet.push(<td width="35px" key={`optcd${i.toString()}`}>{optcd[i]}</td>);
    tdSet.push(<td key={`optbranchno${i.toString()}`}>-{optbranchno[i]}</td>);
    const pricess1Anchor = (
      <a
        role="presentation"
        onClick={() => { onOpenCtrSetGuide('UPD', `${optcd[i]}`, `${optbranchno[i]}`); }}
      ><span style={{ color: '#006699' }}>{optname[i]}</span>
      </a>);
    tdSet.push(<td key={`setcolor${i.toString()}`}><span style={{ color: `#${setcolor[i]}` }} >■</span>{pricess1Anchor}</td>);
    tdSet.push(<td key={`exceptlimit${i.toString()}`}><span style={{ color: 'red' }}>{exceptlimit[i] === 1 && '✔'}</span></td>);
    tdSet.push(<td key={`addcondition${i.toString()}`}>{addcondition[i]}</td>);
    tdSet.push(<td key={`csldivname${i.toString()}`}>{csldivname[i]}</td>);
    tdSet.push(<td key={`gender${i.toString()}`}>{gender[i]}</td>);
    tdSet.push(<td key={`agename${i.toString()}`}>{agename[i]}</td>);

    res.push(<tr key={`${optcd[i]}-${optbranchno[i]}`}>{tdSet}{tdPriceTax}</tr>);
  }
  return res;
};

const CtrDetailListSetPtBody = (props) => {
  const { org, item, sets, onOpenCtrSetGuide, message } = props;

  return (
    <div>
      <MessageBanner messages={message} />
      {sets.optcd && sets.optcd.length > 0 && (
        <Table style={{ width: '95%' }} >
          <thead>
            <tr>
              <th rowSpan="2" colSpan="3">検査セット名</th>
              <th rowSpan="2">限度額<br />対象外</th>
              <th colSpan="4">受診条件</th>
              {item && item.map((rec) => (
                <th colSpan="2" key={rec.seq}>
                  <span>{rec.apdiv === Constants.APDIV_MYORG ? org.orgsname : rec.orgsname}</span>
                </th>
              ))}
              <th colSpan="2" bgcolor="#C6DBF7">合計額</th>
            </tr>
            <tr>
              <th>受診対象</th>
              <th>区分</th>
              <th>性別</th>
              <th>年齢</th>
              <PatternPriceOptsTableHeader data={item} />
              <th bgcolor="#C6DBF7">負担金額</th>
              <th bgcolor="#C6DBF7">消費税</th>
            </tr>
          </thead>
          <tbody>
            <PatternPriceOptsTableBody data={sets} onOpenCtrSetGuide={onOpenCtrSetGuide} />
          </tbody>
        </Table>
      )}
    </div>
  );
};

// propTypesの定義
CtrDetailListSetPtBody.propTypes = {
  onOpenCtrSetGuide: PropTypes.func,
  sets: PropTypes.shape().isRequired,
  org: PropTypes.shape().isRequired,
  item: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
};

CtrDetailListSetPtBody.defaultProps = {
  onOpenCtrSetGuide: () => ({}),
};

const mapStateToProps = (state) => ({
  org: state.app.preference.organization.organizationEdit.org,
  item: state.app.preference.contract.ctrDetailList.item,
  sets: state.app.preference.contract.ctrDetailList.sets,
  message: state.app.preference.contract.ctrDetailList.message,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onOpenCtrSetGuide: (mode, optcd, optbranchno) => {
    // 検査セット登録画面を表示
    dispatch(openCtrSetGuide({ mode, optcd, optbranchno }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CtrDetailListSetPtBody);
