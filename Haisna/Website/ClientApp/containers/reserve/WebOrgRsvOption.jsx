import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { Field, getFormValues, reduxForm } from 'redux-form';
import { FieldGroup, FieldSet } from '../../components/Field';
import Button from '../../components/control/Button';
import SectionBar from '../../components/SectionBar';
import Label from '../../components/control/Label';
import CheckBox from '../../components/control/CheckBox';
import Radio from '../../components/control/Radio';
import Table from '../../components/Table';
import MessageBanner from '../../components/MessageBanner';
import { onChangeCsldivRequset, changeColor } from '../../modules/reserve/webOrgRsvModule';

const formName = 'webOrgRsvOption';


// 金額形式への編集
const formatCurrency = (expression) => {
  // 文字列編集バッファ
  let buffer = '';
  // インデックス
  let i;
  let j;
  const minusSign = expression >= 0 ? '' : '-';
  const editPrice = Math.abs(expression).toString(10);
  for (i = editPrice.length - 1, j = 0; i >= 0; i -= 1) {
    if (buffer !== '' && j + 1 % 3 === 0) {
      buffer = `,${buffer}`;
    }
    buffer = editPrice.charAt(i) + buffer;
  }
  return `${minusSign}\\${buffer}`;
};

// 画面表示
const showLayout = (rec, showall, regflg, handleChangeColorClick) => {
  let res = '';
  const value = null;
  if (rec.hidersv === null || showall === 1) {
    res = (
      <tr key={rec.checkedValue}>
        <td style={{ background: rec.consults === 1 ? '#ffc0cb' : '#ffffff' }}>
          {value}
        </td>
        <td>
          {regflg === '2' && rec.branchcount === 1 &&
            <CheckBox checked={rec.checkValue === rec.checkedValue} />
          }
          {regflg === '2' && rec.branchcount !== 1 &&
            <Radio checked={rec.checkValue === rec.checkedValue} />
          }
          {regflg === '1' && rec.branchcount === 1 &&
            <Field component={CheckBox} name={rec.elementname} checkedValue={rec.checkedValue} onChange={handleChangeColorClick} />
          }
          {regflg === '1' && rec.branchcount !== 1 &&
            <Field component={Radio} name={rec.elementname} checkedValue={rec.checkedValue} onChange={handleChangeColorClick} />
          }
        </td>
        <td>
          <span style={{ color: `#${rec.setcolor}` }}>■</span>{rec.optname}
        </td>
        <td>{formatCurrency(rec.price)}</td>
        <td>{formatCurrency(rec.perprice)}</td>
        <td>{rec.optcd}-{rec.optbranchno}</td>
      </tr>
    );
  }
  return res;
};

class WebOrgRsvOption extends React.Component {
  constructor(props) {
    super(props);
    this.handleOnshowClick = this.handleOnshowClick.bind(this);
    this.handleChangeColorClick = this.handleChangeColorClick.bind(this);
  }
  handleOnshowClick() {
    const { detailFormValues, formValues, onShow, webOrgRsvData, regflg, newctrptcd } = this.props;
    const params = {};
    params.perid = webOrgRsvData.perid;
    params.gender = webOrgRsvData.gender;
    params.birth = webOrgRsvData.birth;
    params.orgcd1 = webOrgRsvData.orgcd1;
    params.orgcd2 = webOrgRsvData.orgcd2;
    params.cscd = webOrgRsvData.cscd;
    params.csldate = detailFormValues.csldate;
    if (detailFormValues) {
      params.csldivcd = detailFormValues.csldivcd;
    }
    params.stomac = webOrgRsvData.optionstomac;
    params.breast = webOrgRsvData.optionbreast;
    params.csloptions = webOrgRsvData.csloptions;
    // 登録済みの場合、常時読み取り専用フラグを送る
    if (regflg === 1) {
      params.readonly = 1;
    }
    // 検査セット画面に全セット表示フラグのエレメントが存在する場合
    params.showall = null;
    if (formValues && formValues.showall !== null) {
      params.showall = formValues.showall;
    }

    // 契約パターンコード指定時
    params.ctrptcd = newctrptcd;
    const optcd = [];
    const optbranchno = [];
    for (let i = 0; i < formValues.ctrptoptfromconsult.length; i += 1) {
      if (formValues.opt.length !== formValues.ctrptoptfromconsult.length
        && formValues.ctrptoptfromconsult[i].consults === 1
        && formValues.ctrptoptfromconsult[i].hidersv !== null) {
        optcd.push(formValues.ctrptoptfromconsult[i].optcd);
        optbranchno.push(formValues.ctrptoptfromconsult[i].optbranchno);
      }
    }

    for (let j = 0; j < formValues.opt.length; j += 1) {
      if (formValues.opt[j] !== null) {
        optcd.push(formValues.opt[j].split(',')[0]);
        optbranchno.push(Number(formValues.opt[j].split(',')[1]));
      }
    }

    // オプションコード指定時
    params.optcd = optcd;
    params.optbranchno = optbranchno;
    onShow(params);
  }
  openCtrDetail() {
    const { history, frameUsedData, newctrptcd } = this.props;
    const { orgcd1, orgcd2, cscd } = frameUsedData;
    history.push(`/contents/preference/contract/organization/${orgcd1}/${orgcd2}/detail/${cscd}/${newctrptcd}`);
  }
  handleChangeColorClick(event) {
    const { ctrptoptfromconsult, onChangeColor } = this.props;
    for (let j = 0; j < ctrptoptfromconsult.length; j += 1) {
      if (event.elementname === ctrptoptfromconsult[j].elementname && ctrptoptfromconsult[j].branchcount !== 1) {
        ctrptoptfromconsult[j].consults = '';
      }
      if (event.checkedValue === ctrptoptfromconsult[j].checkedValue) {
        if (event.consults === 1) {
          ctrptoptfromconsult[j].consults = 0;
        } else {
          ctrptoptfromconsult[j].consults = 1;
        }
      }
    }
    const params = { ctrptoptfromconsult };
    onChangeColor(params);
  }
  render() {
    const { newctrptcd, ctrptoptfromconsult, showall, ctrpt, message, regflg } = this.props;
    return (
      <div style={{ height: '480px', width: '505px', overflow: 'auto' }}>
        <SectionBar title="検査セット" />
        {ctrptoptfromconsult && ctrptoptfromconsult.length === 0 && (
          <MessageBanner messages={message} />
        )}
        {ctrptoptfromconsult && ctrptoptfromconsult.length > 0 && (
          <from>
            <FieldGroup itemWidth={200}>
              <FieldSet>
                <Label>パターンNo.：{newctrptcd}</Label>
                <div style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>
                  <a role="presentation" onClick={() => (this.openCtrDetail())} >
                    この契約を参照
                  </a>
                </div>
                <Field component={CheckBox} name="showall" checkedValue={1} label="すべての検査を" />
                <Button value="表示" onClick={this.handleOnshowClick} />
              </FieldSet>
              <FieldSet>
                <Table>
                  <thead>
                    <tr>
                      <th colSpan="3">検査セット名{ctrpt && ctrpt.csname}</th>
                      <th>負担金額計</th>
                      <th>個人負担分</th>
                      <th>&nbsp;</th>
                    </tr>
                  </thead>
                  <tbody>
                    {ctrptoptfromconsult && ctrptoptfromconsult.map((rec, index) => (
                      showLayout(rec, showall, regflg, () => this.handleChangeColorClick(rec, index))
                    ))}
                  </tbody>
                </Table>
              </FieldSet>
            </FieldGroup>
          </from>
        )}
      </div>
    );
  }
}

const WebOrgRsvNaviForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(WebOrgRsvOption);

WebOrgRsvOption.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string),
  newctrptcd: PropTypes.number,
  ctrpt: PropTypes.shape(),
  showall: PropTypes.number,
  onShow: PropTypes.func.isRequired,
  onChangeColor: PropTypes.func.isRequired,
  detailFormValues: PropTypes.shape(),
  frameUsedData: PropTypes.shape(),
  webOrgRsvData: PropTypes.shape(),
  regflg: PropTypes.number,
  formValues: PropTypes.shape(),
  history: PropTypes.shape().isRequired,
  ctrptoptfromconsult: PropTypes.arrayOf(PropTypes.shape()),
};

WebOrgRsvOption.defaultProps = {
  formValues: null,
  newctrptcd: null,
  regflg: null,
  detailFormValues: null,
  frameUsedData: null,
  webOrgRsvData: null,
  ctrpt: null,
  showall: null,
  ctrptoptfromconsult: [],
  message: [],
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  const detailFormValues = getFormValues('WebOrgRsvDetail')(state);
  return {
    visible: state.app.reserve.webOrgRsv.webOrgRsvMain.visible,
    frameUsedData: state.app.reserve.webOrgRsv.webOrgRsvList.frameUsedData,
    message: state.app.reserve.webOrgRsv.webOrgRsvOptionList.message,
    ctrptoptfromconsult: state.app.reserve.webOrgRsv.webOrgRsvOptionList.ctrptoptfromconsult,
    ctrmng: state.app.reserve.webOrgRsv.webOrgRsvOptionList.ctrmng,
    newctrptcd: state.app.reserve.webOrgRsv.webOrgRsvOptionList.newctrptcd,
    csldate: state.app.reserve.webOrgRsv.webOrgRsvList.csldate,
    webOrgRsvData: state.app.reserve.webOrgRsv.webOrgRsvList.webOrgRsvData,
    regflg: state.app.reserve.webOrgRsv.webOrgRsvList.regflg,
    showall: state.app.reserve.webOrgRsv.webOrgRsvOptionList.showall,
    ctrpt: state.app.reserve.webOrgRsv.webOrgRsvOptionList.ctrpt,
    loadFlg: state.app.reserve.webOrgRsv.webOrgRsvOptionList.loadFlg,
    opt: state.app.reserve.webOrgRsv.webOrgRsvOptionList.opt,
    formValues,
    detailFormValues,
    initialValues: {
      ctrptoptfromconsult: state.app.reserve.webOrgRsv.webOrgRsvOptionList.ctrptoptfromconsult,
      opt: state.app.reserve.webOrgRsv.webOrgRsvOptionList.opt,
      showall: state.app.reserve.webOrgRsv.webOrgRsvOptionList.showall,
    },
  };
};

const mapDispatchToProps = (dispatch) => ({

  onShow(params) {
    dispatch(onChangeCsldivRequset(params));
  },
  onChangeColor(params) {
    dispatch(changeColor(params));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(WebOrgRsvNaviForm));
