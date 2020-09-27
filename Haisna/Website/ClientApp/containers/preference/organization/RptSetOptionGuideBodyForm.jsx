import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, Field } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';
import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import BulletedLabel from '../../../components/control/BulletedLabel';
import Button from '../../../components/control/Button';
import CheckBox from '../../../components/control/CheckBox';

const formName = 'RptSetOptionGuideBodyForm';

const WrapperBulleted = styled.div`
  .bullet { color: #cc9999 };
`;

class RptSetOptionGuideBody extends React.Component {
  constructor(props) {
    super(props);

    this.handleSave = this.handleSave.bind(this);
  }

  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    // フォーム入力内容の初期化
    this.props.reset();

    const { onLoad, conditions } = this.props;
    onLoad(conditions, formName);
  }

  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  // 保存
  handleSave(values) {
    const { conditions, onSave } = this.props;
    const { orgcd1, orgcd2 } = conditions;
    onSave({ ...values, orgcd1, orgcd2 });
  }

  render() {
    const { onClose, handleSubmit, orgName, orgrptoptrptv, orgrptoptrptd } = this.props;

    return (
      <div style={{ marginLeft: '5px', marginRight: '5px' }} >
        <div>
          <Button value="保存" onClick={handleSubmit(this.handleSave)} />
          <Button value="キャンセル" onClick={onClose} />
        </div>
        <div>
          <div style={{ float: 'left' }}>団体名：</div><div style={{ fontWeight: 'bold', color: '#ff6600' }}>{ orgName }</div>
        </div>
        <WrapperBulleted>
          <BulletedLabel>成績書オプション印刷一覧を表示しています。</BulletedLabel>
        </WrapperBulleted>

        <div style={{ marginTop: '20px', marginBottom: '20px', height: '2px', backgroundColor: '#cccccc' }} />

        <WrapperBulleted>
          <BulletedLabel>印刷するオプション項目に<input type="checkbox" defaultChecked="true" />チェックして下さい。</BulletedLabel>
        </WrapperBulleted>
        {orgrptoptrptv.length === 0 && <span>この団体の印刷オプション項目は存在しません。</span>}
        {orgrptoptrptv.length > 0 && (
          <GridList cellHeight="auto" style={{ width: 400 }}>
            {orgrptoptrptv.map((rec, index) => (
              <GridListTile key={rec.rptoptcd}>
                <Field component={CheckBox} name={`orgrptoptrptv[${index}].value_s`} checkedValue="1" label={`${rec.rptoptname}`} />
              </GridListTile>
            ))}
          </GridList>
        )}

        <div style={{ marginTop: '20px', marginBottom: '20px', height: '2px', backgroundColor: '#cccccc' }} />

        <WrapperBulleted>
          <BulletedLabel>印刷しないオプション項目に<input type="checkbox" defaultChecked="true" />チェックして下さい。</BulletedLabel>
        </WrapperBulleted>
        {orgrptoptrptd.length === 0 && <span>この団体の印刷オプション項目は存在しません。</span>}
        {orgrptoptrptd.length > 0 && (
          <GridList cellHeight="auto" style={{ width: 400 }}>
            {orgrptoptrptd.map((rec, index) => (
              <GridListTile key={rec.rptoptcd}>
                <Field component={CheckBox} name={`orgrptoptrptd[${index}].value_s`} checkedValue="1" label={`${rec.rptoptname}`} />
              </GridListTile>
            ))}
          </GridList>
        )}

        <div style={{ marginBottom: '5px', height: '2px' }} />
      </div>
    );
  }
}

// propTypesの定義
RptSetOptionGuideBody.propTypes = {
  // actionと紐付けされた項目
  onClose: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  onSave: PropTypes.func.isRequired,
  // redux-form化によって紐付けされた項目
  handleSubmit: PropTypes.func.isRequired,
  reset: PropTypes.func.isRequired,
  conditions: PropTypes.shape().isRequired,
  orgName: PropTypes.string.isRequired,
  orgrptoptrptv: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  orgrptoptrptd: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

const RptSetOptionGuideBodyForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
})(RptSetOptionGuideBody);

const mapStateToProps = (state) => ({
  orgrptoptrptv: state.app.preference.organization.organizationRptOptionGuide.orgrptoptrptv,
  orgrptoptrptd: state.app.preference.organization.organizationRptOptionGuide.orgrptoptrptd,
});

export default connect(mapStateToProps)(RptSetOptionGuideBodyForm);
