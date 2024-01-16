package kr.co.kalpa.olivia.utils.mybatis.typehandler;

import java.sql.Array;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

public class IntegerArrayTypeHandler extends BaseTypeHandler<List<Integer>>{

	/**
	 * SQL문장을 만들때
	 */
	@Override
	public void setNonNullParameter(PreparedStatement ps, int i, List<Integer> parameter, JdbcType jdbcType)
			throws SQLException {
		if(parameter == null || parameter.size() == 0) {
			ps.setArray(i, null);
			return;
		}
		
		Integer[] ints = parameter.toArray(Integer[]::new);
		ps.setArray(i, ps.getConnection().createArrayOf("int", ints));
	}

	@Override
	public List<Integer> getNullableResult(ResultSet rs, String columnName) throws SQLException {
		return getArrayListFromSqlArray(rs.getArray(columnName));
	}

	@Override
	public List<Integer> getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
		return getArrayListFromSqlArray(rs.getArray(columnIndex));
	}

	@Override
	public List<Integer> getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
		return getArrayListFromSqlArray(cs.getArray(columnIndex));
	}
	private List<Integer> getArrayListFromSqlArray(Array array) throws SQLException {
		if(array == null) return null;
		Integer[] ints = (Integer[])array.getArray();
		if(ints == null	) {
			return null;
		}
		List<Integer> list = new ArrayList<Integer>();
		for(int i=0;i<ints.length;i++) {
			list.add(ints[i]);
		}
		return list;
	}
}
